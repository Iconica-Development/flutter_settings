import "package:flutter/widgets.dart";
import "package:flutter_settings/src/config/options.dart";
import "package:flutter_settings/src/util/pophandler.dart";
import "package:settings_repository/settings_repository.dart";

/// An internally used scope to provide the standard needed options
/// throughout the userstory.
///
/// This is rarely needed outside of the userstory.
class SettingsScope extends InheritedWidget {
  /// Create a settingsScope
  const SettingsScope({
    required this.namespace,
    required this.options,
    required this.service,
    required this.popHandler,
    required super.child,
    super.key,
  });

  ///
  final String namespace;

  ///
  final SettingsOptions options;

  ///
  final SettingsService service;

  ///
  final PopHandler popHandler;

  @override
  bool updateShouldNotify(SettingsScope oldWidget) =>
      oldWidget.namespace != namespace || options != options;

  ///
  static SettingsScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SettingsScope>()!;
}
