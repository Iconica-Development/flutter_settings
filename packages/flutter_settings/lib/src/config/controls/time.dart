import "package:flutter/material.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:settings_repository/settings_repository.dart";

/// Time Control Configuration
class TimeControlConfig
    extends DescriptiveTitleControlConfig<String, TimeControlConfig> {
  /// Constructor for Time Control Config
  TimeControlConfig({
    required super.title,
    required super.description,
    required super.initialValue,
    this.hintText,
    this.suffixIcon,
    this.timeFormat = const ["HH", ":", "mm"],
    super.wrapperBuilder = defaultDescriptionTitleControlWrapper,
  });

  /// Hint text for the time picker
  final String? hintText;

  /// Icon to display as suffix in the input field
  final Widget? suffixIcon;

  /// Time format for displaying the picked time
  final List<String> timeFormat;

  @override
  Widget buildSetting(
    BuildContext context,
    SettingsControl<String> control,
    SettingsControlController controller,
  ) {
    var initialTime =
        control.value != null ? _parseTime(control.value!) : TimeOfDay.now();

    return InkWell(
      onTap: () async {
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
  String _formatTime(TimeOfDay time, List<String> format) {
    var hour24 = time.hour.toString().padLeft(2, "0");
    var hour12 =
        (time.hour % 12 == 0 ? 12 : time.hour % 12).toString().padLeft(2, "0");
    var minute = time.minute.toString().padLeft(2, "0");
    var period = time.hour >= 12 ? "PM" : "AM";

    return format
        .join()
        .replaceAll("HH", hour24)
        .replaceAll("hh", hour12)
        .replaceAll("mm", minute)
        .replaceAll("a", period);
  }

  /// Parse a time string into a `TimeOfDay` object.
  TimeOfDay? _parseTime(String value) {
    try {
      var parts = value.split(":");
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } on Exception {
      return null;
    }
  }
}
