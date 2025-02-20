import "package:flutter/material.dart";
import "package:flutter_settings/src/config/controls/controls.dart";
import "package:settings_repository/settings_repository.dart";

///
class SettingsControlController extends ChangeNotifier {
  ///
  SettingsControlController({
    required Future<void> Function(SettingsControl) onUpdateControl,
    required Future<void> Function(PageControlConfig) onMoveToPage,
    required Future<void> Function(List<SettingsControl<dynamic>>)
        onUpdateAllControls,
    bool autoCommit = true,
  })  : _onUpdateAllControls = onUpdateAllControls,
        _autoCommit = autoCommit,
        _onMoveToPage = onMoveToPage,
        _onUpdateControl = onUpdateControl;

  final Future<void> Function(SettingsControl control) _onUpdateControl;
  final Future<void> Function(PageControlConfig control) _onMoveToPage;
  final Future<void> Function(List<SettingsControl>) _onUpdateAllControls;
  final bool _autoCommit;

  final Map<String, dynamic> _uncomitted = {};

  ///
  List<SettingsControl> mapUncommittedControls(
    List<SettingsControl> controls,
  ) =>
      controls.map((control) {
        var key = control.key;
        if (key != null) {
          if (_uncomitted.containsKey(key)) {
            control = control.update(_uncomitted[key]).save();
          }
        }

        if (control.children?.isNotEmpty ?? false) {
          control = control.copyWith(
            children: mapUncommittedControls(control.children!),
          );
        }

        if (control.dependencies?.isNotEmpty ?? false) {
          control = control.copyWith(
            dependencies: mapUncommittedControls(control.dependencies!),
          );
        }
        return control;
      }).toList();

  ///
  Future<void> commit(List<SettingsControl> controls) async {
    var mapped = mapUncommittedControls(controls);
    _uncomitted.clear();
    await _onUpdateAllControls(mapped);
    notifyListeners();
  }

  ///
  Future<void> updateControl(SettingsControl control) async {
    if (control.key == null) {
      return;
    }

    if (_autoCommit) {
      await _onUpdateControl.call(control);
    } else {
      _uncomitted[control.key!] = control.changedValue;
      notifyListeners();
    }
  }

  ///
  Future<void> moveToPage(PageControlConfig config) async {
    await _onMoveToPage(config);
  }
}
