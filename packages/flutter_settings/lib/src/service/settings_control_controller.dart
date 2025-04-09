import "package:flutter/material.dart";
import "package:flutter_settings/src/config/controls/controls.dart";
import "package:settings_repository/settings_repository.dart";

/// A controller for maintaining all currently edited settings
///
/// Manages saving and local caching.
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

  /// Update controls depending on the current state
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

  /// Update all outstanding changes in controls
  Future<void> commit(List<SettingsControl> controls) async {
    var mapped = mapUncommittedControls(controls);
    _uncomitted.clear();
    await _onUpdateAllControls(mapped);
    notifyListeners();
  }

  /// Updates a control with the new value
  ///
  /// Will automatically save if [autoCommit] is set to true.
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

  /// Move to a different settingspage with PageControlConfig as its base
  Future<void> moveToPage(PageControlConfig config) async {
    await _onMoveToPage(config);
  }
}
