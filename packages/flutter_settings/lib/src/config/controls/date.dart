import "package:flutter/material.dart";
import "package:flutter_iconica_utilities/flutter_iconica_utilities.dart";
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
    super.dependencies = const [],
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
    var firstDate = this.firstDate ?? DateTime(1900);
    var lastDate = this.lastDate ?? DateTime(2100);

    assert(
      firstDate.isBefore(lastDate),
      "The firstDate $firstDate should be before the last date $lastDate",
    );

    var initialDate = control.value != null
        ? DateFormat(dateFormat).parse(control.value!)
        : DateTime.now().clamp(firstDate, lastDate);

    return InkWell(
      onTap: () async {
        var pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate.clamp(firstDate, lastDate),
          firstDate: firstDate,
          lastDate: lastDate,
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
                  suffixIcon: switch (suffixIcon) {
                    null => null,
                    Widget icon => IgnorePointer(child: icon),
                  },
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
