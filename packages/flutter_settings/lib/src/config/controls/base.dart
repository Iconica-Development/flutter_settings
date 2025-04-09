import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:settings_repository/settings_repository.dart";

///
typedef ControlWrapperBuilder<T, C extends SettingsControlConfig<T, C>> = Widget
    Function(
  BuildContext context,
  Widget child,
  SettingsControl<T> control,
  C config,
);

///
abstract class SettingsControlConfig<T, C extends SettingsControlConfig<T, C>> {
  ///
  const SettingsControlConfig({
    required this.initialValue,
    required this.wrapperBuilder,
    required this.dependencies,
  });

  ///
  final SettingsControl<T> initialValue;

  ///
  final ControlWrapperBuilder<T, C> wrapperBuilder;

  ///
  final List<SettingsDependency> dependencies;

  List<SettingsDependency> _bindControlDependencies(
    SettingsControl<T> control,
  ) =>
      dependencies.map((dependency) {
        if (dependency is ControlDependency) {
          return dependency.copyWith(
            control: control.getDependency(dependency.control.key) ??
                dependency.control,
          );
        }
        return dependency;
      }).toList();

  ///
  @nonVirtual
  Widget build(
    BuildContext context,
    SettingsControl<T> control,
    SettingsControlController controller,
  ) {
    var controlWidget = wrapperBuilder(
      context,
      buildSetting(context, control, controller),
      control,
      this as C,
    );

    var dependencies = _bindControlDependencies(control);

    return dependencies.fold(controlWidget, (child, dependencie) {
      var constructedWidget = dependencie.build(context, child);
      if (constructedWidget == null) {
        return child;
      }
      return constructedWidget;
    });
  }

  ///
  Widget buildSetting(
    BuildContext context,
    SettingsControl<T> control,
    SettingsControlController controller,
  );
}

///
abstract class TitleControlConfig<T, C extends SettingsControlConfig<T, C>>
    extends SettingsControlConfig<T, C> {
  ///
  const TitleControlConfig({
    required this.title,
    required super.initialValue,
    required super.wrapperBuilder,
    required super.dependencies,
  }) : super();

  ///
  final String title;
}

///
abstract class DescriptiveTitleControlConfig<T,
    C extends TitleControlConfig<T, C>> extends TitleControlConfig<T, C> {
  ///
  const DescriptiveTitleControlConfig({
    required this.description,
    required super.title,
    required super.initialValue,
    required super.wrapperBuilder,
    required super.dependencies,
  }) : super();

  ///
  final String? description;
}
