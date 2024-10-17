import "package:flutter_settings_repository/src/settings_model.dart";

abstract interface class SettingsRepository {
  Stream<SettingsModel> getSettingsForNamespace(
    String namespace,
  );

  Future<void> saveSettingsForNamespace(
    String namespace,
    SettingsModel model,
  );

  Future<void> saveSingleSettingForNamespace<T>(
    String namespace,
    String setting,
    T value,
  );
}
