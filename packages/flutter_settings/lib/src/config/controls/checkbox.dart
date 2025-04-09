import "package:flutter/material.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:settings_repository/settings_repository.dart";

///
class CheckBoxControlConfig
    extends DescriptiveTitleControlConfig<bool, CheckBoxControlConfig> {
  ///
  const CheckBoxControlConfig({
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
      Checkbox(
        value: control.value ?? false,
        onChanged: (bool? value) async {
          if (value != null) {
            await controller.updateControl(
              control.update(value),
            );
          }
        },
      );
}
