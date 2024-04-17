import 'package:flutter/material.dart';
import 'package:flutter_settings/flutter_settings.dart';
import 'package:flutter_settings/src/ui/control.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceSettingsPage extends SettingsPage {
  DeviceSettingsPage({
    required super.settings,
    this.loadFromPrefs = true,
    this.onSave,
    this.saveToPrefs = true,
    this.theme,
  });

  final bool loadFromPrefs;
  final bool saveToPrefs;
  final Function? onSave;
  final ThemeData? theme;

  @override
  SettingsPageState createState() => _DeviceSettingPageState();
}

class _DeviceSettingPageState extends SettingsPageState<DeviceSettingsPage> {
  late SharedPreferences prefs;

  bool _saveToPrefs(settings) {
    for (Control s in settings) {
      switch (s.type) {
        case ControlType.checkBox:
          prefs.setBool(s.key, s.value);

        case ControlType.number:
          prefs.setDouble(s.key, s.value['selected']);

        case ControlType.dropDown:
          prefs.setInt(s.key, s.value['selected']);

        case ControlType.radio:
          if (s.value['selected'] != null)
            prefs.setInt(s.key, s.value['selected']);

        case ControlType.toggle:
          prefs.setBool(s.key, s.value);

        case ControlType.range:
          prefs.setDouble(s.key, s.value['selected']);

        case ControlType.textField:
          prefs.setString(s.key, s.value ?? '');

        case ControlType.date:
          prefs.setInt(
              s.key, (s.value['selected'] as DateTime).millisecondsSinceEpoch);

        case ControlType.time:
          prefs.setString(s.key,
              '${(s.value as TimeOfDay).hour}:${(s.value as TimeOfDay).minute}');

        case ControlType.dateRange:
          prefs.setString(s.key,
              '${(s.value['selected-start'] as DateTime).millisecondsSinceEpoch}:${(s.value['selected-end'] as DateTime).millisecondsSinceEpoch}');

        case ControlType.group:
          _saveToPrefs(s.settings);

        default:
          break;
      }
    }
    return true;
  }

  bool _loadFromPrefs(settings) {
    if (widget.loadFromPrefs != true) return true;
    for (Control s in settings) {
      switch (s.type) {
        case ControlType.checkBox:
          s.value = prefs.getBool(s.key) ?? s.value;
          break;
        case ControlType.dropDown:
          s.value['selected'] = prefs.getInt(s.key) ?? s.value['selected'];
          break;
        case ControlType.radio:
          s.value['selected'] = prefs.getInt(s.key) ?? s.value['selected'];
          break;
        case ControlType.toggle:
          s.value = prefs.getBool(s.key) ?? s.value;
          break;
        case ControlType.textField:
          s.value = prefs.getString(s.key) ?? s.value;
          break;
        case ControlType.range:
          s.value['selected'] = prefs.getDouble(s.key) ?? s.value['selected'];
          break;
        case ControlType.number:
          s.value['selected'] = prefs.getDouble(s.key) ?? s.value['selected'];
          break;
        case ControlType.date:
          s.value['selected'] = (prefs.getInt(s.key) != null)
              ? DateTime.fromMillisecondsSinceEpoch(prefs.getInt(s.key)!)
              : s.value['selected'];
          break;
        case ControlType.time:
          if (prefs.getString(s.key) != null) {
            List<String> values = prefs.getString(s.key)!.split(':');
            s.value = TimeOfDay(
                hour: int.parse(values[0]), minute: int.parse(values[1]));
          }
          break;
        case ControlType.dateRange:
          if (prefs.getString(s.key) != null) {
            List<String> values = prefs.getString(s.key)!.split(':');
            s.value['selected-start'] =
                DateTime.fromMillisecondsSinceEpoch(int.parse(values[0]));
            s.value['selected-end'] =
                DateTime.fromMillisecondsSinceEpoch(int.parse(values[1]));
          }
          break;
        case ControlType.group:
          _loadFromPrefs(s.settings);
          break;
        default:
          break;
      }
    }
    return true;
  }

  Future<bool> saveSettings() async {
    if (widget.onSave != null) {
      widget.onSave!(widget.settings);
    }

    if (widget.saveToPrefs) {
      _saveToPrefs(widget.settings);
    }

    return true;
  }

  Future<bool> loadSettings() async {
    prefs = await SharedPreferences.getInstance();
    _loadFromPrefs(widget.settings);
    return true;
  }
}
