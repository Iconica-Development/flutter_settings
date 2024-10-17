import "package:flutter/material.dart";
import "package:flutter_settings/src/config/defaults.dart";
import "package:flutter_settings/src/service/settings_control_controller.dart";
import "package:flutter_settings_repository/flutter_settings_repository.dart";

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

  ///
  static SettingsControlConfig toggle({
    required String key,
    required String title,
    String? description,
    ControlWrapperBuilder<bool, ToggleControlConfig>? wrapperBuilder,
  }) =>
      ToggleControlConfig(
        title: title,
        description: description,
        initialValue: SettingsControl(key: key),
        wrapperBuilder: wrapperBuilder ?? defaultDescriptionTitleControlWrapper,
      );

  ///
  static SettingsControlConfig page({
    required String title,
    required List<SettingsControlConfig> children,
    ControlWrapperBuilder<Never, PageControlConfig>? wrapperBuilder,
    String? description,
  }) {
    assert(
      children.isNotEmpty,
      "You cannot create a page setting without providing at least 1 child.",
    );
    var innerControls = children.map((child) => child.initialValue).toList();

    return PageControlConfig(
      children: children,
      title: title,
      description: description,
      initialValue: SettingsControl(key: null, children: innerControls),
      wrapperBuilder: wrapperBuilder ?? defaultDescriptionTitleControlWrapper,
    );
  }

  ///
  static SettingsControlConfig group({
    required String title,
    required List<SettingsControlConfig> children,
    ControlWrapperBuilder<Never, GroupControlConfig>? wrapperBuilder,
    String? description,
  }) {
    assert(
      children.isNotEmpty,
      "You cannot create a group setting without providing at least 1 child.",
    );
    var innerControls = children.map((child) => child.initialValue).toList();

    return GroupControlConfig(
      description: description,
      children: children,
      title: title,
      initialValue: SettingsControl(key: null, children: innerControls),
      wrapperBuilder: wrapperBuilder ?? defaultGroupControlWrapper,
    );
  }
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

///
class ToggleControlConfig
    extends DescriptiveTitleControlConfig<bool, ToggleControlConfig> {
  ///
  ToggleControlConfig({
    required super.title,
    required super.description,
    required super.initialValue,
    super.wrapperBuilder = defaultDescriptionTitleControlWrapper,
  }) : super();

  @override
  Widget buildSetting(
    BuildContext context,
    SettingsControl<bool> control,
    SettingsControlController controller,
  ) =>
      Switch(
        value: control.value ?? false,
        onChanged: (value) async {
          await controller.updateControl(control.update(value));
        },
      );
}

///
class PageControlConfig
    extends DescriptiveTitleControlConfig<Never, PageControlConfig> {
  ///
  PageControlConfig({
    required this.children,
    required super.title,
    required super.initialValue,
    required super.wrapperBuilder,
    super.description,
  }) : super();

  ///
  final List<SettingsControlConfig> children;

  @override
  Widget buildSetting(
    BuildContext context,
    SettingsControl<Never> control,
    SettingsControlController controller,
  ) =>
      IconButton(
        icon: const Icon(Icons.chevron_right),
        onPressed: () async {
          await controller.moveToPage(this);
        },
      );
}

///
class GroupControlConfig
    extends SettingsControlConfig<Never, GroupControlConfig> {
  ///
  GroupControlConfig({
    required this.title,
    required this.description,
    required this.children,
    required super.initialValue,
    required super.wrapperBuilder,
  }) : super();

  ///
  final List<SettingsControlConfig> children;

  ///
  final String title;

  ///
  final String? description;

  @override
  Widget buildSetting(
    BuildContext context,
    SettingsControl<Never> control,
    SettingsControlController controller,
  ) {
    SettingsControl getControlAt(int index) =>
        control.children?.elementAt(index) ??
        children.elementAt(index).initialValue;

    return Column(
      children: [
        for (var index in children.indexed) ...[
          index.$2.build(context, getControlAt(index.$1), controller),
        ],
      ],
    );
  }
}
