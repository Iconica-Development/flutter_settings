import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:settings_repository/settings_repository.dart";

/// Text Control Configuration
class TextControlConfig
    extends DescriptiveTitleControlConfig<String, TextControlConfig> {
  /// Constructor for Text Control Config
  const TextControlConfig({
    required super.title,
    required super.description,
    required super.initialValue,
    this.decoration,
    this.hintText,
    this.validator,
    this.inputFormatters,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    super.wrapperBuilder = defaultDescriptionTitleControlWrapper,
    super.dependencies = const [],
  });

  /// Optional decoration for the textFormField
  final InputDecoration? decoration;

  /// Hint text displayed in the text field
  final String? hintText;

  /// Optional validator function for the text input
  final String? Function(String?)? validator;

  /// Input formatters to limit input types, e.g., numerical input only
  final List<TextInputFormatter>? inputFormatters;

  /// Keyboard type for the text field, e.g., text, number, email
  final TextInputType keyboardType;

  /// Maximum number of lines for multiline text input
  final int maxLines;

  @override
  Widget buildSetting(
    BuildContext context,
    SettingsControl<String> control,
    SettingsControlController controller,
  ) =>
      Expanded(
        child: TextFormField(
          initialValue: control.value,
          decoration: decoration,
          keyboardType: keyboardType,
          validator: validator,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          onChanged: (String value) async {
            await controller.updateControl(control.update(value));
          },
        ),
      );
}
