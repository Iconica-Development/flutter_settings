import "package:flutter/material.dart";
import "package:flutter_settings/src/service/settings_control_controller.dart";
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
  SettingsControlConfig({
    required this.initialValue,
    required this.wrapperBuilder,
  });

  ///
  final SettingsControl<T> initialValue;

  ///
  final ControlWrapperBuilder<T, C> wrapperBuilder;

  ///
  Widget build(
    BuildContext context,
    SettingsControl<T> control,
    SettingsControlController controller,
  ) =>
      wrapperBuilder(
        context,
        buildSetting(context, control, controller),
        control,
        this as C,
      );

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
  TitleControlConfig({
    required this.title,
    required super.initialValue,
    required super.wrapperBuilder,
  }) : super();

  ///
  final String title;
}

///
abstract class DescriptiveTitleControlConfig<T,
    C extends TitleControlConfig<T, C>> extends TitleControlConfig<T, C> {
  ///
  DescriptiveTitleControlConfig({
    required this.description,
    required super.title,
    required super.initialValue,
    required super.wrapperBuilder,
  }) : super();

  ///
  final String? description;
}
