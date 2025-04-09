import "package:flutter/material.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:settings_repository/settings_repository.dart";

/// Dropdown Control Configuration
class DropdownControlConfig
    extends DescriptiveTitleControlConfig<String, DropdownControlConfig> {
  /// Constructor for Dropdown Control Config
  const DropdownControlConfig({
    required super.title,
    required super.description,
    required super.initialValue,
    required this.options,
    this.hintText,
    this.suffixIcon,
    this.inputDecoration, // Custom decoration parameter
    super.wrapperBuilder = defaultDescriptionTitleControlWrapper,
    super.dependencies = const [],
  });

  /// List of items for the dropdown control
  final List<String> options;

  /// Optional hint text displayed in the dropdown
  final String? hintText;

  /// Suffix icon for the dropdown
  final Widget? suffixIcon;

  /// Optional custom `InputDecoration` for the dropdown
  final InputDecoration? inputDecoration;

  @override
  Widget buildSetting(
    BuildContext context,
    SettingsControl<String> control,
    SettingsControlController controller,
  ) =>
      Expanded(
        child: DropdownButtonFormField<String>(
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
          ),
          items: options
              .map(
                (String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: (String? value) async {
            if (value != null) {
              await controller.updateControl(control.update(value));
            }
          },
          value: control.value,
          hint: switch (hintText) {
            null => null,
            String text => Text(text),
          },
          decoration: inputDecoration ??
              InputDecoration(
                suffixIcon: switch (suffixIcon) {
                  null => null,
                  Widget icon => IgnorePointer(child: icon),
                },
              ),
        ),
      );
}
