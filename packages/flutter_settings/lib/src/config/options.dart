import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:flutter_settings/src/ui/defaults/default_base_screen.dart";
import "package:flutter_settings/src/ui/defaults/default_buttons.dart";
import "package:settings_repository/settings_repository.dart";

/// The type of save mode
enum SettingsSaveMode {
  /// Save settings when the user leaves the page
  onExitPage,

  /// Save settings when the user leaves the settings screens
  onExitUserstory,

  /// Save settings as soon as they are changed
  onChanged,

  /// Save settings by pressing a button at the bottom of the screen
  button;
}

/// All options available for the settings userstory
class SettingsOptions {
  /// Create options to use in the settings userstory.
  SettingsOptions({
    required this.controls,
    this.saveMode = SettingsSaveMode.onChanged,
    this.primaryButtonBuilder = DefaultPrimaryButton.builder,
    this.baseScreenBuilder = DefaultBaseScreen.builder,
    SettingsRepository? repository,
  }) : repository = repository ?? LocalSettingsRepository();

  /// The method of saving settings, mainly dictates at what point the settings
  /// are persisted.
  final SettingsSaveMode saveMode;

  /// A list of control configs to define what settings are available
  final List<SettingsControlConfig> controls;

  ///
  final SettingsRepository repository;

  /// A method to wrap your settings screens with a base frame.
  ///
  /// If you provide a screen here make sure to use a [Scaffold], as some
  /// elements require a [Material] or other elements that a [Scaffold]
  /// provides
  final BaseScreenBuilder baseScreenBuilder;

  /// A way to provide your own primary button implementation
  final ButtonBuilder primaryButtonBuilder;
}

///
class DynamicSettingsOptions {
  /// Create options to use in the settings userstory.
  DynamicSettingsOptions({
    this.saveMode = SettingsSaveMode.onChanged,
    this.primaryButtonBuilder = DefaultPrimaryButton.builder,
    this.baseScreenBuilder = DefaultBaseScreen.builder,
    this.mappings = defaultDynamicSettingControlMappings,
    SettingsRepository? repository,
    DynamicSettingsRepository? dynamicRepository,
  })  : repository = repository ?? LocalSettingsRepository(),
        dynamicRepository =
            dynamicRepository ?? LocalDynamicSettingsRepository();

  /// The method of saving settings, mainly dictates at what point the settings
  /// are persisted.
  final SettingsSaveMode saveMode;

  ///
  final SettingsRepository repository;

  ///
  final DynamicSettingsRepository dynamicRepository;

  /// A method to wrap your settings screens with a base frame.
  ///
  /// If you provide a screen here make sure to use a [Scaffold], as some
  /// elements require a [Material] or other elements that a [Scaffold]
  /// provides
  final BaseScreenBuilder baseScreenBuilder;

  /// A way to provide your own primary button implementation
  final ButtonBuilder primaryButtonBuilder;

  /// All possible mappings that are map to a setting.
  ///
  /// The key of this map is matched with a DynamicSetting
  final Map<String, DynamicSettingToControlMapping> mappings;
}

///
typedef BaseScreenBuilder = Widget Function(
  BuildContext context,
  VoidCallback onBack,
  Widget child,
);

/// Builder definition for providing a button implementation
typedef ButtonBuilder = Widget Function(
  BuildContext context,
  FutureOr<void>? Function()? onPressed,
  Widget child,
);

/// Definition of setting to control mapping configuration
typedef DynamicSettingControlMappings
    = Map<String, DynamicSettingToControlMapping>;

/// Quick check to determine if a setting is supported
extension DynamicSettingControlMappingSupport on DynamicSettingControlMappings {
  /// Whether [setting] is supported given current
  /// [DynamicSettingControlMappings]
  bool isSettingSupported(DynamicSetting setting) =>
      keys.contains(setting.type);

  /// Creates a control given the dynamic setting.
  ///
  /// Make sure that the setting is supported first by calling
  /// [isSettingSupported], otherwise a [StateError] is thrown
  SettingsControlConfig createControl(
    DynamicSetting setting,
    List<SettingsControlConfig> children,
  ) {
    var builder = this[setting.type];
    if (builder == null) {
      throw StateError(
        "This set of mappings does not support this type: ${setting.type}."
        " First check whether the given type is supported",
      );
    }

    return builder(setting, children);
  }
}

/// A mapping that defines how a dynamic control is made.
class DynamicSettingControlMapping {
  final DynamicSettingType type;
}

/// Definition for the mapping controls from dynamic settings
typedef DynamicSettingToControlMapping = SettingsControlConfig Function(
  DynamicSetting setting,
  List<SettingsControlConfig> children,
);
