import "package:flutter/material.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:settings_repository/settings_repository.dart";

///
class RadioControlConfig<T>
    extends DescriptiveTitleControlConfig<T, RadioControlConfig<T>> {
  ///
  RadioControlConfig({
    required super.title,
    required super.description,
    required super.initialValue,
    required this.options,
    super.wrapperBuilder = defaultDescriptionTitleControlWrapper,
  });

  ///
  final List<T> options;

  @override
  Widget buildSetting(
    BuildContext context,
    SettingsControl<T> control,
    SettingsControlController controller,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var option in options)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: RadioListTile<T>(
                title: Text(option.toString()),
                value: option,
                groupValue: control.value,
                onChanged: (T? value) async {
                  if (value != null) {
                    await controller.updateControl(control.update(value));
                  }
                },
              ),
            ),
        ],
      );
}
