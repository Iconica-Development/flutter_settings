import "package:flutter/widgets.dart";
import "package:settings_repository/settings_repository.dart";

/// Signature of a function that builds the widget tree given a dependency
typedef ControlDependencyBuilder<T> = Widget? Function(
  BuildContext,
  Widget,
  SettingsControl<T>,
);

/// Configuration class for defining dependencies on another Control
final class ControlDependency<T> implements SettingsDependency {
  /// Instantiates a dependency onto a control
  const ControlDependency({
    required this.control,
    required this.builder,
  });

  /// The control on which to depend
  final SettingsControl<T> control;

  /// The function that allows for changing of the outcome depending on the
  /// given [control]
  final ControlDependencyBuilder<T> builder;

  @override
  Widget? build(BuildContext context, Widget child) =>
      builder(context, child, control);

  /// Creates a new instance of a dependency with the given fields replaced
  /// compared to this instance
  ControlDependency<T> copyWith({
    SettingsControl<T>? control,
    ControlDependencyBuilder<T>? builder,
  }) =>
      ControlDependency(
        control: control ?? this.control,
        builder: builder ?? this.builder,
      );
}

/// Basic dependency
///
/// Should only be used for dynamic builds based on a changed logical dependency
/// If you want to change the input or the container, take a look at the
/// builders provided in the [SettingsControlConfig]
// ignore: one_member_abstracts
abstract class SettingsDependency {
  /// Returns a widget based on the current context
  Widget? build(BuildContext context, Widget child);
}

/// Extension to allow for easier extraction of controls from dependencies
extension GetControls on List<SettingsDependency> {
  /// Retrieve all controls in the dependencies
  List<SettingsControl> getControlDependencies() =>
      whereType<ControlDependency>()
          .map((dependency) => dependency.control)
          .toList();
}
