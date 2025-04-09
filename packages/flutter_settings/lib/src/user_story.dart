import "package:flutter/material.dart";
import "package:flutter_settings/src/config/options.dart";
import "package:flutter_settings/src/ui/settings_screen.dart";
import "package:flutter_settings/src/util/pophandler.dart";
import "package:flutter_settings/src/util/scope.dart";
import "package:settings_repository/settings_repository.dart";

/// This pushes the Settings user story to the navigator stack.
Future<void> openSettingsForNamespace(
  BuildContext context, {
  required String namespace,
  required SettingsOptions options,
}) async {
  var navigator = Navigator.of(context);

  await navigator.push(
    SettingsUserStory.route(
      namespace,
      options,
      () => navigator.pop(),
    ),
  );
}

/// The base of the settings userstory.
///
/// This allows you to include fully navigatable settings in your app,
/// depending on the [options] given.
///
/// The [namespace] is used so multiple settings instances can be used
/// throughout the app. If you want to save settings per user, you could
/// provide a user-id here.
class SettingsUserStory extends StatefulWidget {
  /// Creates a Settings user story
  const SettingsUserStory({
    required this.options,
    this.namespace = "default_settings",
    this.onExit,
    super.key,
  });

  /// A route to easily push the userstory on top of your current navigator
  static MaterialPageRoute route(
    String namespace,
    SettingsOptions options,
    VoidCallback? onExit,
  ) =>
      MaterialPageRoute(
        builder: (context) => SettingsUserStory(
          namespace: namespace,
          options: options,
          onExit: onExit,
        ),
      );

  /// The domain namespace that identifies these settings.
  ///
  /// If used as settings on an internal
  final String namespace;

  /// The options on which this userstory will depend
  final SettingsOptions options;

  /// The function invoked when the user intents to leave the settings userstory
  ///
  /// Invoked if the base screen invokes onBack, if an intent is given to pop
  /// the screen or otherwise a [Navigator.pop] is called.
  final VoidCallback? onExit;

  @override
  State<SettingsUserStory> createState() => _SettingsUserStoryState();
}

class _SettingsUserStoryState extends State<SettingsUserStory> {
  late SettingsService _settingsService = SettingsService(
    namespace: widget.namespace,
    repository: widget.options.repository,
  );

  late final PopHandler _popHandler = PopHandler();

  @override
  void didUpdateWidget(covariant SettingsUserStory oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.namespace != widget.namespace ||
        oldWidget.options != widget.options) {
      setState(() {
        _settingsService = SettingsService(
          namespace: widget.namespace,
          repository: widget.options.repository,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) => SettingsScope(
        namespace: widget.namespace,
        options: widget.options,
        service: _settingsService,
        popHandler: _popHandler,
        child: NavigatorPopHandler(
          onPop: _popHandler.handlePop,
          child: Navigator(
            onGenerateInitialRoutes: (state, route) => [
              MaterialPageRoute(
                builder: (context) => SettingsScreen(
                  controls: widget.options.controls,
                  options: widget.options,
                  onExit: () => widget.onExit?.call(),
                ),
              ),
            ],
          ),
        ),
      );
}
