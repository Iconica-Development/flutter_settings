import "package:flutter/material.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:intl/intl.dart";
import "package:settings_repository/settings_repository.dart";

/// Time Control Configuration
///
/// Requires localizations to be set up
class TimeControlConfig
    extends DescriptiveTitleControlConfig<String, TimeControlConfig> {
  /// Constructor for Time Control Config
  TimeControlConfig({
    required super.title,
    required super.description,
    required super.initialValue,
    this.hintText,
    this.suffixIcon,
    this.timeFormat,
    super.wrapperBuilder = defaultDescriptionTitleControlWrapper,
  });

  /// Hint text for the time picker
  final String? hintText;

  /// Icon to display as suffix in the input field
  final Widget? suffixIcon;

  /// Time format for displaying the picked time
  ///
  /// Using a dateformat that includes year, month or day will result in
  /// 0 values being displayed.
  final DateFormat? timeFormat;

  @override
  Widget buildSetting(
    BuildContext context,
    SettingsControl<String> control,
    SettingsControlController controller,
  ) {
    var timeFormat = this.timeFormat ??
        DateFormat(
          "HH:mm",
          Localizations.maybeLocaleOf(context)?.languageCode,
        );

    var initialTime = control.value != null
        ? _parseTime(
            control.value!,
            timeFormat,
          )
        : TimeOfDay.now();

    return TextButton(
      onPressed: () async {
        var pickedTime = await showTimePicker(
          context: context,
          initialTime: initialTime ?? TimeOfDay.now(),
        );

        if (pickedTime != null) {
          var formattedTime = _formatTime(pickedTime, timeFormat);
          await controller.updateControl(control.update(formattedTime));
        }
      },
      child: Text(
        control.value ?? hintText ?? "Select Time",
      ),
    );
  }

  /// Format the `TimeOfDay` into a string using the given `timeFormat`.
  String _formatTime(TimeOfDay time, DateFormat format) {
    var date = DateTime(0, 0, 0, time.hour, time.minute);
    return format.format(date);
  }

  /// Parse a time string into a `TimeOfDay` object.
  TimeOfDay? _parseTime(String value, DateFormat format) {
    try {
      var dateTime = format.parse(value);
      return TimeOfDay.fromDateTime(dateTime);
    } on Exception {
      return null;
    }
  }
}
