import "package:flutter/material.dart";
import "package:flutter_settings/src/config/controls/base.dart";
import "package:flutter_settings/src/service/settings_control_controller.dart";
import "package:settings_repository/settings_repository.dart";

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
