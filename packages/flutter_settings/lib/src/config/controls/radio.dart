import "package:flutter/material.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:settings_repository/settings_repository.dart";

///
class RadioControlConfig
    extends DescriptiveTitleControlConfig<String, RadioControlConfig> {
  ///
  RadioControlConfig({
    required super.title,
    required super.description,
    required super.initialValue,
    required this.options,
    super.wrapperBuilder = defaultDescriptionTitleControlWrapper,
  });

  ///
  final List<String> options;

  @override
  Widget buildSetting(
    BuildContext context,
    SettingsControl<String> control,
    SettingsControlController controller,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options
            .map(
              (String option) => ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: control.value,
                  onChanged: (String? value) async {
                    if (value != null) {
                      await controller.updateControl(control.update(value));
                    }
                  },
                ),
              ),
            )
            .toList(),
      );
}
