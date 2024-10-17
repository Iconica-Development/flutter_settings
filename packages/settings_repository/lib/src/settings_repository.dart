import "package:settings_repository/src/settings_model.dart";

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

  Future<SettingsModel> getSettingsAsFuture<T>(
    String namespace,
  );

  Future<void> deleteNamespace(
    String namespace,
  );

  Future<void> deleteSettingForNamespace(
    String namespace,
    String setting,
  );
}
