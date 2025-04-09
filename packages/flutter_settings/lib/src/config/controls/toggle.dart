import "package:flutter/material.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:settings_repository/settings_repository.dart";

///
class ToggleControlConfig
    extends DescriptiveTitleControlConfig<bool, ToggleControlConfig> {
  ///
  const ToggleControlConfig({
    required super.title,
    required super.description,
    required super.initialValue,
    super.wrapperBuilder = defaultDescriptionTitleControlWrapper,
    super.dependencies = const [],
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
