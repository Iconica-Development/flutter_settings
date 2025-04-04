import "package:settings_repository/src/dynamic_settings/dynamic_setting.dart";

abstract interface class DynamicSettingsRepository {
  Future<void> createNamespace(String namespace);

  Future<void> deleteNamespace(String namespace);

  Stream<List<DynamicSettingsNamespace>> getNamespaces();

  Future<void> addDynamicSettingForNamespace(
    DynamicSetting setting,
    String namespace,
  );

  Future<void> removeDynamicSettingForNamespace(
    DynamicSetting setting,
    String namespace,
  );

  Stream<List<DynamicSetting>> getDynamicSettingsForNamespace(
    String namespace,
  );
}

class NamespaceDoesNotExistException implements Exception {}

class NamespaceAlreadyExistsException implements Exception {}
