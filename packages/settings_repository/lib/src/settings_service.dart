import "package:settings_repository/src/controls.dart";
import "package:settings_repository/src/save_mode.dart";
import "package:settings_repository/src/settings_model.dart";
import "package:settings_repository/src/settings_repository.dart";

/// A service for handling the transformation between [SettingsModel]
/// and a list [SettingsControl].
///
/// This service contains no state and can be created in any context, given that
/// the correct repository is provided.
class SettingsService {
  /// Create an instance of this service within a given [namespace].
  ///
  /// The [namespace] is an extra reference to save settings in. The purpose of
  /// the [namespace] property is to allow for multi-domain usage of this
  /// package without having to think about possible duplicate key usage cross
  /// domains.
  ///
  /// The method of saving and reading settings is determined by the type of
  /// [repository] given. You can look at existing packages, like the firebase
  /// or device settings repositories, or if you are testing use the
  /// [LocalSettingsRepository]
  const SettingsService({
    required String namespace,
    required SettingsRepository repository,
  })  : _repository = repository,
        _namespace = namespace;

  final String _namespace;
  final SettingsRepository _repository;

  /// Simple method of retrieving the settings, returns it as a [Stream]
  ///
  /// If you want it as a [Future], simply call the [Stream.first] for the
  /// first Settings update in the stream and await it.
  Stream<SettingsModel> getSettings() =>
      _repository.getSettingsForNamespace(_namespace);

  /// Simple method of retrieving as single setting, returns it as a [Stream]
  ///
  /// If you want it as a [Future], simply call the [Stream.first] for the
  /// latest Settings update in the stream and await it.
  Stream<T?> getValue<T>(String key, T? Function() orElse) =>
      getSettings().map((value) => value.getSetting(key) ?? orElse());

  /// A [Stream] of [SettingsControl]s that automatically binds the values to
  /// the given [controls]
  ///
  /// If you want it as a [Future], simply call the [Stream.last] for the latest
  /// Settings update in the stream and await it.
  Stream<List<SettingsControl>> getSettingsAsControls(
    List<SettingsControl> controls,
  ) =>
      getSettings().map((settings) => controls.bindSettings(settings));

  /// A simple method to save a single setting
  Future<void> setValue<T>(String key, T value) async {
    await _repository.saveSingleSettingForNamespace(_namespace, key, value);
  }

  /// Save a single control
  Future<void> saveControl<T>(SettingsControl<T> control) async {
    if (control.key == null) {
      return;
    }

    await setValue(control.key!, control.changedValue);
  }

  /// Save controls through either the one-by-one or allAtOnce strategy
  Future<List<SettingsControl>> saveControls(
    List<SettingsControl> controls, {
    SettingsSaveStrategy saveMode = SettingsSaveStrategy.allAtOnce,
  }) async {
    await switch (saveMode) {
      SettingsSaveStrategy.allAtOnce => _saveAllControls(controls),
      SettingsSaveStrategy.oncePerSetting => _saveChangedControls(controls),
    };

    return controls.map((control) => control.save()).toList();
  }

  Future<void> _saveChangedControls(List<SettingsControl> controls) async {
    await Future.wait<void>([
      for (var control in controls) ...[
        if (control.requiresSaving) saveControl(control),
      ],
    ]);
  }

  Future<void> _saveAllControls(List<SettingsControl> controls) async {
    var model = controls.toSettingsModel();
    await _repository.saveSettingsForNamespace(_namespace, model);
  }
}
