import "package:flutter/material.dart";
import "package:flutter_settings/src/config/options.dart";
import "package:flutter_settings/src/ui/settings_screen.dart";
import "package:flutter_settings/src/util/pophandler.dart";
import "package:flutter_settings/src/util/scope.dart";
import "package:settings_repository/settings_repository.dart";

/// This pushes the Settings user story to the navigator stack.
Future<void> openSettingsForNamespace(
  BuildContext context,
  String userId,
  SettingsOptions options,
) async {
  var navigator = Navigator.of(context);

  await navigator.push(
    SettingsUserStory.route(
      userId,
      options,
      () => navigator.pop(),
    ),
  );
}

///
class SettingsUserStory extends StatefulWidget {
  ///
  const SettingsUserStory({
    required this.options,
    this.namespace = "default_settings",
    this.onExit,
    super.key,
  });

  ///
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

  ///
  final SettingsOptions options;

  ///
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
