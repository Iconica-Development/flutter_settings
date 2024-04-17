import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_settings/flutter_settings.dart';

class ProfileSettingsPage extends SettingsPage {
  const ProfileSettingsPage({required super.settings, super.key});

  @override
  State<StatefulWidget> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends SettingsPageState<ProfileSettingsPage> {
  Map<String, dynamic> profile = {};

  @override
  Future<bool> loadSettings() async {
    // profile = await context.appShellBackend().getUserprofile();
    _loadFromProfile(widget.settings);
    return true;
  }

  void _loadFromProfile(List<Control> settings) {
    for (var s in settings) {
      switch (s.type) {
        case ControlType.checkBox:
        case ControlType.toggle:
          s.value = profile[s.key];

        case ControlType.dropDown:
        case ControlType.radio:
        case ControlType.toggle:
          s.value['selected'] = profile[s.key];

        case ControlType.number:
        case ControlType.range:
          s.value['selected'] = (profile[s.key])?.toDouble() ?? 0.0;

        case ControlType.textField:
          s.value = profile[s.key];

        case ControlType.group:
          _loadFromProfile(s.settings!);

        case ControlType.date:
          s.value['selected'] = (profile[s.key] != null)
              ? DateTime.fromMillisecondsSinceEpoch(profile[s.key])
              : s.value['selected'];

        case ControlType.time:
          if (profile[s.key] != null) {
            List<String> values = profile[s.key].split(':');
            s.value = TimeOfDay(
              hour: int.parse(values[0]),
              minute: int.parse(values[1]),
            );
          }

        case ControlType.dateRange:
          if (profile[s.key] != null) {
            List<String> values = profile[s.key].split(':');
            s.value['selected-start'] =
                DateTime.fromMillisecondsSinceEpoch(int.parse(values[0]));
            s.value['selected-end'] =
                DateTime.fromMillisecondsSinceEpoch(int.parse(values[1]));
          }

        default:
          break;
      }
    }
  }

  void _saveToProfile(List<Control> settings) {
    for (var s in settings) {
      switch (s.type) {
        case ControlType.checkBox:
        case ControlType.toggle:
          profile[s.key] = s.value;

        case ControlType.number:
        case ControlType.dropDown:
        case ControlType.radio:
        case ControlType.toggle:
        case ControlType.range:
          profile[s.key] = s.value['selected'];

        case ControlType.textField:
          profile[s.key] = s.value;

        case ControlType.group:
          _saveToProfile(s.settings!);

        case ControlType.date:
          profile[s.key] =
              (s.value['selected'] as DateTime).millisecondsSinceEpoch;

        case ControlType.time:
          profile[s.key] =
              '${(s.value as TimeOfDay).hour}:${(s.value as TimeOfDay).minute}';

        case ControlType.dateRange:
          profile[s.key] =
              '${(s.value['selected-start'] as DateTime).millisecondsSinceEpoch}:${(s.value['selected-end'] as DateTime).millisecondsSinceEpoch}';

        default:
          break;
      }
    }
  }

  @override
  Future<bool> saveSettings() async {
    _saveToProfile(widget.settings);
    profile.removeWhere((key, value) => value is Uint8List);
    // await context.appShellBackend().saveUserprofile(profile);
    return true;
  }
}
