import 'package:flutter/material.dart';
import 'package:flutter_settings/flutter_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceSettingsPage extends SettingsPage {
  const DeviceSettingsPage({
    required super.settings,
    super.controlWrapper,
    super.groupWrapper,
    super.key,
    this.loadFromPrefs = true,
    this.onSave,
    this.saveToPrefs = true,
    this.theme,
  });

  final bool loadFromPrefs;
  final bool saveToPrefs;
  final Future<void> Function(List<Control>)? onSave;
  final ThemeData? theme;

  @override
  SettingsPageState createState() => _DeviceSettingPageState();
}

class _DeviceSettingPageState extends SettingsPageState<DeviceSettingsPage> {
  late SharedPreferences prefs;

  Future<bool> _saveToPrefs(settings) async {
    for (Control s in settings) {
      switch (s.type) {
        case ControlType.checkBox:
          await prefs.setBool(s.key, s.value);

        case ControlType.number:
          await prefs.setInt(s.key, (s.value as Map)['selected']);

        case ControlType.dropDown:
          if ((s.value as Map)['selected'] != null)
            await prefs.setString(s.key, (s.value as Map)['selected']);

        // case ControlType.radio:
        //   if (s.value['selected'] != null)
        //     await prefs.setInt(s.key, s.value['selected']);

        case ControlType.toggle:
          await prefs.setBool(s.key, s.value);

        // case ControlType.range:
        //   await prefs.setDouble(s.key, s.value['selected']);

        case ControlType.textField:
          await prefs.setString(s.key, s.value ?? '');

        case ControlType.date:
          await prefs.setInt(
            s.key,
            ((s.value as Map)['selected'] as DateTime).millisecondsSinceEpoch,
          );

        case ControlType.time:
          await prefs.setString(
            s.key,
            '${(s.value as TimeOfDay).hour}:${(s.value as TimeOfDay).minute}',
          );

        case ControlType.dateRange:
          await prefs.setString(
            s.key,
            // ignore: lines_longer_than_80_chars
            '${((s.value as Map)['selected-start'] as DateTime).millisecondsSinceEpoch}:${((s.value as Map)['selected-end'] as DateTime).millisecondsSinceEpoch}',
          );

        case ControlType.group:
          await _saveToPrefs(s.settings);

        default:
          break;
      }
    }
    return true;
  }

  bool _loadFromPrefs(settings) {
    if (!widget.loadFromPrefs) return true;
    for (Control s in settings) {
      switch (s.type) {
        case ControlType.checkBox:
          s.value = prefs.getBool(s.key) ?? s.value;

        case ControlType.dropDown:
          (s.value as Map)['selected'] =
              prefs.getString(s.key) ?? (s.value as Map)['selected'];

        // case ControlType.radio:
        //   s.value['selected'] = prefs.getInt(s.key) ?? s.value['selected'];

        case ControlType.toggle:
          s.value = prefs.getBool(s.key) ?? s.value;

        case ControlType.textField:
          s.value = prefs.getString(s.key) ?? s.value;

        // case ControlType.range:
        // s.value['selected'] = prefs.getDouble(s.key) ?? s.value['selected'];

        case ControlType.number:
          (s.value as Map)['selected'] = prefs.getInt(s.key) ??
              (s.value as Map)['selected'];

        case ControlType.date:
          (s.value as Map)['selected'] = (prefs.getInt(s.key) != null)
              ? DateTime.fromMillisecondsSinceEpoch(prefs.getInt(s.key)!)
              : (s.value as Map)['selected'];

        case ControlType.time:
          if (prefs.getString(s.key) != null) {
            var values = prefs.getString(s.key)!.split(':');
            s.value = TimeOfDay(
              hour: int.parse(values[0]),
              minute: int.parse(values[1]),
            );
          }

        case ControlType.dateRange:
          if (prefs.getString(s.key) != null) {
            var values = prefs.getString(s.key)!.split(':');
            (s.value as Map)['selected-start'] =
                DateTime.fromMillisecondsSinceEpoch(int.parse(values[0]));
            (s.value as Map)['selected-end'] =
                DateTime.fromMillisecondsSinceEpoch(int.parse(values[1]));
          }

        case ControlType.group:
          _loadFromPrefs(s.settings);

        default:
          break;
      }
    }
    return true;
  }

  @override
  Future<bool> saveSettings() async {
    await widget.onSave?.call(widget.settings);

    if (widget.saveToPrefs) {
      await _saveToPrefs(widget.settings);
    }

    return true;
  }

  @override
  Future<bool> loadSettings() async {
    prefs = await SharedPreferences.getInstance();
    _loadFromPrefs(widget.settings);
    return true;
  }
}
