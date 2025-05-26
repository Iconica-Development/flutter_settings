import "package:flutter/widgets.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:settings_repository/settings_repository.dart";
import "package:sleek_circular_slider/sleek_circular_slider.dart";

/// A control that supports duration selection, and saves it as its
/// time in milliseconds
class DurationControlConfig
    extends DescriptiveTitleControlConfig<int, DurationControlConfig> {
  /// Creates a control in which you can edit a Duration value. Saved as a
  /// integer in milliseconds
  DurationControlConfig({
    required String key,
    required super.title,
    this.stepSize = const Duration(milliseconds: 100),
    this.wheelSize = const Duration(seconds: 10),
    super.dependencies = const [],
    super.description,
    super.wrapperBuilder = defaultDescriptionTitleControlWrapper,
  }) : super(
          initialValue: SettingsControl(key: key),
        );

  /// To what duration each stap should snap
  ///
  /// e.g.: 100 millis snaps to 0, 100, 200, 300, 400... millis.
  final Duration stepSize;

  /// How much time a single iteration of the wheel should represent
  final Duration wheelSize;

  @override
  Widget buildSetting(
    BuildContext context,
    SettingsControl<int> control,
    SettingsControlController controller,
  ) {
    var currentDuration = Duration(milliseconds: control.value ?? 0);
    return _DurationInput(
      stepSize: stepSize,
      wheelSize: wheelSize,
      duration: currentDuration,
      onDurationChanged: (duration) async =>
          controller.updateControl(control.update(duration.inMilliseconds)),
    );
  }
}

class _DurationInput extends StatefulWidget {
  const _DurationInput({
    required this.stepSize,
    required this.wheelSize,
    required this.duration,
    required this.onDurationChanged,
  });

  final Duration stepSize;
  final Duration wheelSize;
  final Duration duration;
  final void Function(Duration duration) onDurationChanged;

  @override
  State<_DurationInput> createState() => __DurationInputState();
}

class __DurationInputState extends State<_DurationInput> {
  bool isEditing = false;
  double? value;

  void _startEditing() => setState(
        () => isEditing = true,
      );

  void _stopEditing() => setState(
        () => isEditing = false,
      );

  void _updateValue(double value) => setState(
        () => this.value = value,
      );

  Duration _roundToStep(Duration duration) {
    var steps = duration.inMilliseconds ~/ widget.stepSize.inMilliseconds;
    return widget.stepSize * steps;
  }

  Duration get _currentDuration {
    var value = this.value;
    if (value == null || !isEditing) {
      return widget.duration;
    }

    if (value == 0) {
      return Duration.zero;
    }

    var durationInMicroSeconds = widget.wheelSize.inMicroseconds * value;

    return _roundToStep(Duration(microseconds: durationInMicroSeconds.toInt()));
  }

  double get _currentSliderPosition {
    var durationValue = switch (_currentDuration) {
      Duration.zero => 0.0,
      Duration currentDuration =>
        widget.wheelSize.inMicroseconds / currentDuration.inMicroseconds,
    };

    if (isEditing) {
      return value ?? durationValue;
    }

    return durationValue;
  }

  @override
  Widget build(BuildContext context) => SleekCircularSlider(
        initialValue: _currentSliderPosition,
        onChangeStart: (_) => _startEditing(),
        onChangeEnd: (_) => _stopEditing(),
        onChange: _updateValue,
      );
}
