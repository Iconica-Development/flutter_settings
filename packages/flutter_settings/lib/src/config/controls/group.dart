import "package:flutter/material.dart";
import "package:flutter_settings/src/config/controls/base.dart";
import "package:flutter_settings/src/service/settings_control_controller.dart";
import "package:settings_repository/settings_repository.dart";

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
    super.dependencies = const [],
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
