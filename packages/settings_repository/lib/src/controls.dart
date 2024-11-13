import "package:settings_repository/src/settings_model.dart";

class SettingsControl<T> {
  SettingsControl({
    required this.key,
    this.value,
    this.defaultValue,
    this.children,
  }) : changedValue = value;

  SettingsControl._internal({
    required this.key,
    required this.value,
    required this.defaultValue,
    required this.changedValue,
    required this.children,
  });

  final T? value;
  final T? changedValue;
  final String? key;
  final T? defaultValue;

  final List<SettingsControl>? children;

  bool get requiresSaving => value != changedValue;

  SettingsControl<T> update(T value) => copyWith(
        changedValue: value,
      );

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

  SettingsControl<T> bindMap(SettingsModel settingsModel) {
    var value = this.value;
    var children = this.children;

    if (key != null) {
      value = settingsModel.getSetting(key!) ?? defaultValue;
    }

    if (children != null) {
      children = children.map((e) => e.bindMap(settingsModel)).toList();
    }

    return SettingsControl<T>(
      key: key,
      value: value,
      defaultValue: defaultValue,
      children: children,
    );
  }

  Map<String, dynamic> toFlatMap() {
    var children = this.children ?? [];
    return {
      if (key != null) ...{
        key!: changedValue,
      },
      for (var item in children) ...item.toFlatMap(),
    };
  }

  SettingsControl<T> copyWith({
    T? value,
    T? changedValue,
    List<SettingsControl>? children,
  }) =>
      SettingsControl._internal(
        key: key,
        value: value ?? this.value,
        changedValue: changedValue ?? this.changedValue,
        defaultValue: defaultValue,
        children: children ?? this.children,
      );
}

extension ToSettingsModel on List<SettingsControl> {
  SettingsModel toSettingsModel() => SettingsModel(
        data: {
          for (var control in this) ...control.toFlatMap(),
        },
      );
}

extension BindMap on List<SettingsControl> {
  List<SettingsControl> bindSettings(SettingsModel settings) =>
      map((e) => e.bindMap(settings)).toList();
}
