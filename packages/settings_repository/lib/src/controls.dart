import "package:settings_repository/src/settings_model.dart";

/// A model to contain all data related to a setting
///
/// Settings are inherently related to other settings, so the goal of this model
/// is to allow relations amongst each setting.
///
/// The translation of data is done using this model, by allowing a flat map
/// of key values when storing settings, and getting a relational model back
/// when loading them.
///
/// If you want the setting to not save anything, then you can set the [key] to
/// [null].
///
/// To provide the current value of a control, simply supply the [value].
/// [changedValue] will be set to the given [value]. If the setting is then
/// updated using [update], the value will be changed accordingly.
///
/// In order to see if a setting requires saving use the [requiresSaving]
/// property. To then save the setting, use the [save] method.
class SettingsControl<T> {
  /// Create an instance of a settingsControl.
  ///
  /// Make sure that the generic type [T] is a value that is easily
  /// serializable for the various repository implementations. It is save to
  /// stick to the primitives like [String] [int] and [bool].
  SettingsControl({
    required this.key,
    this.value,
    this.defaultValue,
    this.children,
    this.dependencies = const [],
  }) : changedValue = value;

  SettingsControl._internal({
    required this.key,
    required this.value,
    required this.defaultValue,
    required this.changedValue,
    required this.children,
    required this.dependencies,
  });

  /// The current value representing the stored value
  final T? value;

  /// The value that was edited, but never saved.
  final T? changedValue;

  /// The key at which to store the setting.
  ///
  /// A unique identifier for this setting. It is not wrong to have two
  /// [SettingsControl]s with the same [key], but know that in binding these
  /// will always contain the same value after saving.
  final String? key;

  /// The default value assigned to the setting when no stored value is found.
  final T? defaultValue;

  /// A list of child settings associated with this setting.
  final List<SettingsControl>? children;

  /// A list of settings that this setting depends on.
  final List<SettingsControl>? dependencies;

  bool get requiresSaving => value != changedValue;

  /// Returns `true` if the setting has unsaved changes.
  SettingsControl<T> update(T value) => copyWith(
        changedValue: value,
      );

  /// Saves the current changed value and returns a new instance with the saved
  /// value.
  SettingsControl<T> save() {
    var children = this.children;

    if (children != null) {
      children = children.map((e) => e.save()).toList();
    }

    return SettingsControl<T>(
      key: key,
      value: changedValue,
      defaultValue: defaultValue,
      children: children,
    );
  }

  /// Binds the current settings model to retrieve values from [settingsModel].
  ///
  /// If the setting has a [key], it will attempt to fetch its value from
  /// [settingsModel], defaulting to [defaultValue] if not found.
  ///
  /// Child settings and dependencies are also recursively updated.
  SettingsControl<T> bindMap(SettingsModel settingsModel) {
    var value = this.value;
    var children = this.children;
    var dependencies = this.dependencies;

    if (key != null) {
      value = settingsModel.getSetting(key!) ?? defaultValue;
    }

    if (children != null) {
      children = children.map((e) => e.bindMap(settingsModel)).toList();
    }

    if (dependencies != null) {
      dependencies = dependencies
          .map((dependencie) => dependencie.bindMap(settingsModel))
          .toList();
    }

    return SettingsControl<T>(
      key: key,
      value: value,
      defaultValue: defaultValue,
      children: children,
      dependencies: dependencies,
    );
  }

  /// Converts the settings structure into a flat map representation.
  ///
  /// Returns a key-value [Map] where each setting with a [key] is included.
  Map<String, dynamic> toFlatMap() {
    var children = this.children ?? [];
    return {
      if (key != null) ...{
        key!: changedValue,
      },
      for (var item in children) ...item.toFlatMap(),
    };
  }

  /// Creates a copy of this [SettingsControl] with optional modifications.
  SettingsControl<T> copyWith({
    T? value,
    T? changedValue,
    List<SettingsControl>? children,
    List<SettingsControl>? dependencies,
  }) =>
      SettingsControl._internal(
        key: key,
        value: value ?? this.value,
        changedValue: changedValue ?? this.changedValue,
        defaultValue: defaultValue,
        children: children ?? this.children,
        dependencies: dependencies ?? this.dependencies,
      );

  /// Retrieves a dependency by its [key], if it exists.
  ///
  /// Returns `null` if no matching dependency is found.
  SettingsControl? getDependency(String? key) {
    if (key == null) {
      return null;
    }
    return dependencies
        ?.where((dependency) => dependency.key == key)
        .firstOrNull;
  }
}

/// Extension to convert a [List] of [SettingsControl] into a [SettingsModel].
extension ToSettingsModel on List<SettingsControl> {
  /// Converts the [List] of settings into a [SettingsModel] representation.
  SettingsModel toSettingsModel() => SettingsModel(
        data: {
          for (var control in this) ...control.toFlatMap(),
        },
      );
}

/// Extension to bind a list of [SettingsControl] to a [SettingsModel].
extension BindMap on List<SettingsControl> {
  /// Binds each [SettingsControl] in the list to values from [settings].
  ///
  /// Returns a new list of [SettingsControl] with updated values.
  List<SettingsControl> bindSettings(SettingsModel settings) =>
      map((e) => e.bindMap(settings)).toList();
}
