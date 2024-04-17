import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_settings/src/ui/control.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  late List<Control> _currentSettings;
  final StreamController<Control> _controller = StreamController.broadcast();
  Future<void> loadSettings(List<Control> settings) async {
    var prefs = await SharedPreferences.getInstance();
    _currentSettings = _initSettings(prefs, settings);
    for (var setting in _currentSettings) {
      _controller.add(setting);
      setting.addListener(() {
        _controller.add(setting);
      });
    }
  }

  Stream<Control> getControlsAsStream() => _controller.stream;

  Stream<dynamic> getValueAsStream(String key) {
    if (_currentSettings.any((element) => element.key == key)) {
      return _controller.stream
          .where((event) => event.key == key)
          .map((event) => event.getValue());
    } else {
      throw 'Expected a control of key $key to exist but no control has been '
          'found to listen to!';
    }
  }

  List<Control> _initSettings(SharedPreferences prefs, List<Control> controls) {
    var flatControl = <Control>[];
    for (var s in controls) {
      switch (s.type) {
        case ControlType.checkBox:
          s.value = prefs.getBool(s.key) ?? s.value;

        case ControlType.dropDown:
          s.value['selected'] = prefs.getInt(s.key) ?? s.value['selected'];

        case ControlType.radio:
          s.value['selected'] = prefs.getInt(s.key) ?? s.value['selected'];

        case ControlType.toggle:
          s.value = prefs.getBool(s.key) ?? s.value;

        case ControlType.textField:
          s.value = prefs.getString(s.key) ?? s.value;

        case ControlType.range:
          s.value['selected'] = prefs.getDouble(s.key) ?? s.value['selected'];

        case ControlType.number:
          s.value['selected'] = prefs.getDouble(s.key) ?? s.value['selected'];

        case ControlType.date:
          s.value['selected'] = (prefs.getInt(s.key) != null)
              ? DateTime.fromMillisecondsSinceEpoch(prefs.getInt(s.key)!)
              : s.value['selected'];

        case ControlType.time:
          if (prefs.getString(s.key) != null) {
            var values = prefs.getString(s.key)!.split(':');
            s.value = TimeOfDay(
                hour: int.parse(values[0]), minute: int.parse(values[1]));
          }

        case ControlType.dateRange:
          if (prefs.getString(s.key) != null) {
            var values = prefs.getString(s.key)!.split(':');
            s.value['selected-start'] =
                DateTime.fromMillisecondsSinceEpoch(int.parse(values[0]));
            s.value['selected-end'] =
                DateTime.fromMillisecondsSinceEpoch(int.parse(values[1]));
          }

        case ControlType.group:
        case ControlType.page:
          var subSet = _initSettings(prefs, s.settings!);
          flatControl.addAll(subSet);

        default:
          break;
      }
    }
    flatControl.addAll(
      controls.where(
        (element) =>
            ![ControlType.group, ControlType.page].contains(element.type),
      ),
    );
    return flatControl;
  }

  Control? getControl(String key) {
    for (var s in _currentSettings) {
      if (s.key == key) {
        return s;
      }
    }
    return null;
  }

  dynamic getSetting(String key) {
    for (var s in _currentSettings) {
      if (s.key == key) {
        if (s.value is Map) {
          if ((s.value as Map).containsKey('selected-start') &&
              (s.value as Map).containsKey('selected-end')) {
            return DateTimeRange(
              start: s.value['selected-start'],
              end: s.value['selected-end'],
            );
          } else {
            return s.value['selected'];
          }
        }
        return s.value;
      }
    }
    return null;
  }

  void dispose() {
    unawaited(_controller.close());
  }
}
