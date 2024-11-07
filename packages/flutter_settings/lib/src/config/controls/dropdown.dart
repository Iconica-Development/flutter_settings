import "package:flutter/material.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:settings_repository/settings_repository.dart";

/// Dropdown Control Configuration
class DropdownControlConfig
    extends DescriptiveTitleControlConfig<String, DropdownControlConfig> {
  /// Constructor for Dropdown Control Config
  DropdownControlConfig({
    required super.title,
    required super.description,
    required super.initialValue,
    required this.options,
    this.hintText,
    this.suffixIcon,
    this.inputDecoration, // Custom decoration parameter
    super.wrapperBuilder = defaultDescriptionTitleControlWrapper,
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
  ) {
    var theme = Theme.of(context);
    return Expanded(
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
        hint: Text(hintText ?? ""),
        decoration: inputDecoration ??
            InputDecoration(
              fillColor: theme.colorScheme.surface,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              suffixIcon: suffixIcon,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
      ),
    );
  }
}
