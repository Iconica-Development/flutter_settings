///
library device_settings_repository;

import "dart:async";
import "dart:convert";

import "package:rxdart/subjects.dart";
import "package:settings_repository/settings_repository.dart";
import "package:shared_preferences/shared_preferences.dart";

/// A repository that saves all settings on device through the
/// Shared preferences user-story
class DeviceSettingsRepository implements SettingsRepository {
  SharedPreferences? _sharedPreferences;

  Future<SharedPreferences> get _prefs async =>
      _sharedPreferences ?? await SharedPreferences.getInstance();

  /// Stores the settings per namespace
  Map<String, Map<String, dynamic>> namespaces = {};

  /// A stream controller to notify listeners of changes per namespace
  Map<String, BehaviorSubject<SettingsModel>> streams = {};

  /// Gets the stream controller for a given namespace or creates a new one
  /// if it doesn't exist
  BehaviorSubject<SettingsModel> getControllerForNamespace(String namespace) =>
      streams[namespace] ??= BehaviorSubject<SettingsModel>();

  Future<void> _saveNamespace(String namespace) async {
    var prefs = await _prefs;
    await prefs.setString(namespace, jsonEncode(namespaces[namespace]));
  }

  Future<SettingsModel> _loadForNamespace(String namespace) async {
    var prefs = await _prefs;

    var raw = prefs.getString(namespace);

    if (raw == null) {
      namespaces[namespace] = {};
      return const SettingsModel(data: {});
    }

    namespaces[namespace] = jsonDecode(raw);

    return SettingsModel(data: namespaces[namespace]!);
  }

  @override
  Stream<SettingsModel> getSettingsForNamespace(String namespace) {
    unawaited(
      _loadForNamespace(namespace)
          .then(getControllerForNamespace(namespace).add),
    );

    return getControllerForNamespace(namespace).stream;
  }

  @override
  Future<void> saveSettingsForNamespace(
    String namespace,
    SettingsModel model,
  ) async {
    await _loadForNamespace(namespace);

    namespaces[namespace] = {
      ...?namespaces[namespace],
      ...model.data,
    };

    await _saveNamespace(namespace);
    getControllerForNamespace(namespace).add(
      SettingsModel(
        data: namespaces[namespace]!,
      ),
    );
  }

  @override
  Future<void> saveSingleSettingForNamespace<T>(
    String namespace,
    String setting,
    T value,
  ) async {
    await _loadForNamespace(namespace);

    var rawSettings = namespaces[namespace] ??= {};
    rawSettings[setting] = value;

    getControllerForNamespace(namespace).add(
      SettingsModel(
        data: rawSettings,
      ),
    );

    await _saveNamespace(namespace);
  }

  @override
  Future<void> deleteNamespace(String namespace) async {
    await _loadForNamespace(namespace);
    var rawSettings = namespaces[namespace];
    if (rawSettings == null) {
      return;
    }

    rawSettings.clear();

    getControllerForNamespace(namespace).add(SettingsModel(data: rawSettings));

    await _saveNamespace(namespace);
  }

  @override
  Future<void> deleteSettingForNamespace(
    String namespace,
    String setting,
  ) async {
    await _loadForNamespace(namespace);
    var rawSettings = namespaces[namespace] ??= {};
    rawSettings.remove(setting);

    getControllerForNamespace(namespace).add(SettingsModel(data: rawSettings));

    await _saveNamespace(namespace);
  }

  @override
  Future<SettingsModel> getSettingsAsFuture<T>(String namespace) async =>
      _loadForNamespace(namespace);
}
