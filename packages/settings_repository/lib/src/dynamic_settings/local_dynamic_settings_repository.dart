import "dart:async";

import "package:rxdart/subjects.dart";
import "package:settings_repository/src/dynamic_settings/dynamic_setting.dart";
import "package:settings_repository/src/dynamic_settings/dynamic_settings_repository.dart";

class LocalDynamicSettingsRepository implements DynamicSettingsRepository {
  factory LocalDynamicSettingsRepository() =>
      instance ??= LocalDynamicSettingsRepository._();

  LocalDynamicSettingsRepository._();

  static LocalDynamicSettingsRepository? instance;

  final List<String> _namespaces = [];
  final StreamController<List<String>> _namespaceStream =
      BehaviorSubject<List<String>>();
  final Map<String, BehaviorSubject<List<DynamicSetting>>> _settingsStreams =
      {};
  final Map<String, List<DynamicSetting>> _settings = {};

  @override
  Future<void> createNamespace(String namespace) async {
    if (_namespaces.contains(namespace)) {
      throw NamespaceAlreadyExistsException();
    }
    _namespaces.add(namespace);
    _namespaceStream.add(List.from(_namespaces));
    _settingsStreams[namespace] = BehaviorSubject()..add([]);
  }

  @override
  Future<void> deleteNamespace(String namespace) async {
    if (_namespaces.contains(namespace)) {
      _namespaces.remove(namespace);
      _namespaceStream.add(List.from(_namespaces));
      await _settingsStreams[namespace]?.close();
      _settingsStreams.remove(namespace);
    }
  }

  @override
  Stream<List<DynamicSettingsNamespace>> getNamespaces() =>
      _namespaceStream.stream.map(
        (namespaces) => namespaces
            .map(
              (namespace) => DynamicSettingsNamespace(
                namespace: namespace,
                settingCount: _settings[namespace]?.length ?? 0,
              ),
            )
            .toList(),
      );

  @override
  Future<void> addDynamicSettingForNamespace(
    DynamicSetting setting,
    String namespace,
  ) async {
    _validateNamespace(namespace);
    var settings = _settings[namespace];
    _settings[namespace] = [
      ...?settings,
      setting,
    ];
    _settingsStreams[namespace]?.add(List.from(_settings[namespace]!));
  }

  void _validateNamespace(String namespace) {
    if (!_namespaces.contains(namespace)) {
      throw NamespaceDoesNotExistException();
    }
  }

  @override
  Future<void> removeDynamicSettingForNamespace(
    DynamicSetting setting,
    String namespace,
  ) async {
    _validateNamespace(namespace);
    var settings = _settings[namespace];
    _settings[namespace] = [
      if (settings != null)
        for (var s in settings)
          if (s.id != setting.id) s,
    ];
    _settingsStreams[namespace]?.add(List.from(_settings[namespace]!));
  }

  @override
  Stream<List<DynamicSetting>> getDynamicSettingsForNamespace(
    String namespace,
  ) {
    _validateNamespace(namespace);
    return _settingsStreams[namespace]!.stream;
  }
}
