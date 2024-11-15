import "package:flutter/material.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:intl/intl.dart";
import "package:settings_repository/settings_repository.dart";

/// Date Control Configuration
class DateControlConfig
    extends DescriptiveTitleControlConfig<String, DateControlConfig> {
  /// Constructor for Date Control Config
  DateControlConfig({
    required super.title,
    required super.description,
    required super.initialValue,
    this.maxwidth,
    this.hintText,
    this.suffixIcon,
    this.dateFormat = "dd-MM-yyyy",
    this.firstDate,
    this.lastDate,
    this.inputDecoration,
    super.wrapperBuilder = defaultDescriptionTitleControlWrapper,
  });

  /// Max width for the input field
  final double? maxwidth;

  /// Hint text for the date picker
  final String? hintText;

  /// Icon to display as suffix in the input field
  final Widget? suffixIcon;

  /// Date format (using `intl` package)
  final String? dateFormat;

  /// Minimum selectable date
  final DateTime? firstDate;

  /// Maximum selectable date
  final DateTime? lastDate;

  /// Optional custom `InputDecoration` for the date control
  final InputDecoration? inputDecoration;

  @override
  Widget buildSetting(
    BuildContext context,
    SettingsControl<String> control,
    SettingsControlController controller,
  ) {
    var theme = Theme.of(context);
    var initialDate = control.value != null
        ? DateFormat(dateFormat).parse(control.value!)
        : DateTime.now();

    return InkWell(
      onTap: () async {
        var pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(1900),
          lastDate: lastDate ?? DateTime(2100),
        );

        if (pickedDate != null) {
          var formattedDate = DateFormat(dateFormat).format(pickedDate);
          await controller.updateControl(control.update(formattedDate));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          constraints: BoxConstraints(maxWidth: maxwidth ?? 200),
          child: InputDecorator(
            decoration: inputDecoration ??
                InputDecoration(
                  hintText: hintText,
                  suffixIcon: suffixIcon,
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: theme.colorScheme.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: theme.colorScheme.error, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
            child: Text(
              control.value ?? hintText ?? "Select a date",
            ),
          ),
        ),
      ),
    );
  }
}
