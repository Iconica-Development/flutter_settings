import "package:flutter_settings/src/config/settings_control.dart";
import "package:flutter_settings_repository/flutter_settings_repository.dart";

///
class SettingsControlController {
  ///
  SettingsControlController({
    required Future<void> Function(SettingsControl) onUpdateControl,
    required Future<void> Function(PageControlConfig) onMoveToPage,
  })  : _onMoveToPage = onMoveToPage,
        _onUpdateControl = onUpdateControl;

  final Future<void> Function(SettingsControl control) _onUpdateControl;
  final Future<void> Function(PageControlConfig control) _onMoveToPage;

  ///
  Future<void> updateControl(SettingsControl control) async {
    await _onUpdateControl.call(control);
  }

  ///
  Future<void> moveToPage(PageControlConfig config) async {
    await _onMoveToPage(config);
  }
}
