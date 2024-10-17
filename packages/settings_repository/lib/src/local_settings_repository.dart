import "dart:async";

import "package:rxdart/subjects.dart";
import "package:settings_repository/settings_repository.dart";

class LocalSettingsRepository implements SettingsRepository {
  factory LocalSettingsRepository() =>
      _instance ??= LocalSettingsRepository._();

  LocalSettingsRepository._();

  static LocalSettingsRepository? _instance;

  final Map<String, dynamic> settingsStore = {};

  final StreamController<SettingsModel> settingsStream = BehaviorSubject();

  @override
  Stream<SettingsModel> getSettingsForNamespace(String namespace) =>
      settingsStream.stream;

  @override
  Future<void> saveSettingsForNamespace(
    String namespace,
    SettingsModel model,
  ) async {
    settingsStore.addAll(model.data);

    settingsStream.add(SettingsModel(data: settingsStore));
  }

  @override
  Future<void> saveSingleSettingForNamespace<T>(
    String namespace,
    String setting,
    T value,
  ) async {
    settingsStore[setting] = value;
    settingsStream.add(SettingsModel(data: settingsStore));
  }

  @override
  Future<void> deleteNamespace(String namespace) async {
    settingsStore.clear();
    settingsStream.add(SettingsModel(data: settingsStore));
  }

  @override
  Future<void> deleteSettingForNamespace(
    String namespace,
    String setting,
  ) async {
    settingsStore.remove(setting);
    settingsStream.add(SettingsModel(data: settingsStore));
  }

  @override
  Future<SettingsModel> getSettingsAsFuture<T>(String namespace) async =>
      SettingsModel(data: settingsStore);
}
