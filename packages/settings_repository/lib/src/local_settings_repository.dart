import "dart:async";

import "package:rxdart/subjects.dart";
import "package:settings_repository/settings_repository.dart";

/// An in memory implementation of [SettingsRepository]
class LocalSettingsRepository implements SettingsRepository {
  /// Creates an instance of [LocalSettingsRepository]
  factory LocalSettingsRepository() =>
      _instance ??= LocalSettingsRepository._();

  LocalSettingsRepository._();

  static LocalSettingsRepository? _instance;

  /// Stores all settings in memory
  final Map<String, dynamic> settingsStore = {};

  /// A stream controller to notify listeners of changes
  final StreamController<SettingsModel> settingsStream = BehaviorSubject();

  @override
  Stream<SettingsModel> getSettingsForNamespace(String namespace) {
    settingsStream.add(SettingsModel(data: settingsStore));
    return settingsStream.stream;
  }

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
