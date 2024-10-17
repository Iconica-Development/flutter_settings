import "dart:async";

import "package:flutter_settings_repository/flutter_settings_repository.dart";
import "package:rxdart/subjects.dart";

class LocalSettingsRepository implements SettingsRepository {
  factory LocalSettingsRepository() =>
      _instance ??= LocalSettingsRepository._();

  LocalSettingsRepository._();

  static LocalSettingsRepository? _instance;

  final Map<String, dynamic> settingsStore = {};

  final StreamController<SettingsModel> settingsStream = BehaviorSubject();

  @override
  Stream<SettingsModel> getSettingsForNamespace(String userId) =>
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
}
