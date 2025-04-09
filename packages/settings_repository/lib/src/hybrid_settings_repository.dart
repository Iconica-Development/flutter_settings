import "package:rxdart/rxdart.dart";
import "package:settings_repository/settings_repository.dart";

/// A repository implementation to enable handling multiple repository types
/// for a single settings solution.
class HybridSettingsRepository implements SettingsRepository {

  /// Creates a hybrid repository to divide settings across multiple
  /// datasources
  HybridSettingsRepository({
    required this.baseRepository,
    required this.alternateRepositories,
  });

  /// The primary repository in which to store/read settings.
  final SettingsRepository baseRepository;

  /// The alternate sources in which the store/read settings
  final List<AlternateSettingsRepository> alternateRepositories;

  Iterable<Future<void>> _executeForAllAlternates(
    Future<void> Function(SettingsRepository repository) handler,
  ) =>
      alternateRepositories
          .map((alternate) async => handler(alternate.settingsRepository));

  @override
  Future<void> deleteNamespace(String namespace) async {
    await Future.wait([
      baseRepository.deleteNamespace(namespace),
      ..._executeForAllAlternates(
        (repository) => repository.deleteNamespace(namespace),
      ),
    ]);
  }

  @override
  Future<void> deleteSettingForNamespace(
    String namespace,
    String setting,
  ) {
    var repository = _getRepositoryForSetting(setting);

    return repository.deleteSettingForNamespace(namespace, setting);
  }

  SettingsRepository _getRepositoryForSetting(String setting) =>
      alternateRepositories
          .where((alternate) => alternate.isAlternateFor(setting))
          .lastOrNull
          ?.settingsRepository ??
      baseRepository;

  @override
  Future<SettingsModel> getSettingsAsFuture<T>(String namespace) async {
    var models = await Future.wait([
      baseRepository.getSettingsAsFuture(namespace),
      ...alternateRepositories.map(
        (alternate) =>
            alternate.settingsRepository.getSettingsAsFuture(namespace),
      ),
    ]);

    return models
        .reduce((base, alternate) => alternate.mergeWithPrevious(base));
  }

  @override
  Stream<SettingsModel> getSettingsForNamespace(String namespace) =>
      Rx.combineLatestList<SettingsModel>(
        [
          baseRepository.getSettingsForNamespace(namespace),
          ...alternateRepositories.map(
            (alternate) => alternate._getSettingsForNamespace(namespace),
          ),
        ],
      ).map(
        (settings) => settings.reduce(
          (base, alternate) => alternate.mergeWithPrevious(base),
        ),
      );

  @override
  Future<void> saveSettingsForNamespace(
    String namespace,
    SettingsModel model,
  ) async {
    var strippedSettings = alternateRepositories.fold(
      model,
      (previous, alternate) => alternate._stripSettings(previous),
    );

    await Future.wait([
      baseRepository.saveSettingsForNamespace(namespace, strippedSettings),
      ..._executeForAllAlternates(
        (repo) => repo.saveSettingsForNamespace(namespace, model),
      ),
    ]);
  }

  @override
  Future<void> saveSingleSettingForNamespace<T>(
    String namespace,
    String setting,
    T value,
  ) {
    var repository = _getRepositoryForSetting(setting);

    return repository.saveSingleSettingForNamespace(namespace, setting, value);
  }
}

/// A grouping between a repository and the keys for which the repository should
/// be used.
class AlternateSettingsRepository {

  /// Create an alternative to the base settings repository.
  AlternateSettingsRepository({
    required this.settingKeys,
    required this.settingsRepository,
  });

  /// The keys for which this repository is used
  final List<String> settingKeys;

  /// The repository to be used when any key is matched
  final SettingsRepository settingsRepository;

  /// Whether the current alternate is correct for the given key.
  bool isAlternateFor(String key) => settingKeys.contains(key);

  Stream<SettingsModel> _getSettingsForNamespace(String namespace) =>
      settingsRepository.getSettingsForNamespace(namespace).map(
            (settings) => SettingsModel(
              data: {
                for (var entry in settings.data.entries) ...{
                  if (isAlternateFor(entry.key)) entry.key: entry.value,
                },
              },
            ),
          );

  SettingsModel _stripSettings(SettingsModel settingsModel) => SettingsModel(
        data: Map.from(settingsModel.data)
          ..removeWhere(
            (key, _) => settingKeys.contains(key),
          ),
      );
}
