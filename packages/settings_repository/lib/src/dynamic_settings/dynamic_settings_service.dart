import "package:settings_repository/src/dynamic_settings/dynamic_setting.dart";
import "package:settings_repository/src/dynamic_settings/dynamic_settings_repository.dart";

class DynamicSettingsService {
  DynamicSettingsService({
    required this.repository,
  });

  final DynamicSettingsRepository repository;

  Future<void> addDynamicSetting(
    DynamicSetting dynamicSetting,
    String namespace,
  ) async =>
      repository.addDynamicSettingForNamespace(dynamicSetting, namespace);

  Future<void> removeDynamicSetting(
    DynamicSetting setting,
    String namespace,
  ) async =>
      repository.removeDynamicSettingForNamespace(setting, namespace);

  Stream<List<DynamicSetting>> getDynamicSettingsForNamespace(
    String namespace,
  ) =>
      repository.getDynamicSettingsForNamespace(namespace);

  Stream<List<DynamicSettingsNamespace>> getNamespaces() =>
      repository.getNamespaces();

  Future<void> createNamespace(String namespace) async =>
      repository.createNamespace(namespace);

  Future<void> deleteNamespace(String namespace) async =>
      repository.deleteNamespace(namespace);

  List<DynamicSetting> getChildrenForSetting(
    List<DynamicSetting> dynamicSettings,
    DynamicSetting parent,
  ) =>
      dynamicSettings.where((setting) => setting.parent == parent.id).toList();
}
