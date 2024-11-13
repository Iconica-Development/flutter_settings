import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_settings/src/config/controls/base.dart";
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
