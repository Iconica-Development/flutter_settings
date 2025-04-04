import "package:flutter/material.dart";
import "package:flutter_settings/src/config/options.dart";
import "package:flutter_settings/src/ui/dynamic/admin/dynamic_settings_admin_screen.dart";
import "package:flutter_settings/src/ui/dynamic/dynamic_settings_screen.dart";
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

/// A dynamic version of the settings user story.
///
/// The goal of this is to have the settings be a determined by an admin, so
/// that possible settings can be changed without the need for an app update.
///
/// Possible use-cases for this are custom forms or new a type of notification.
/// Or to simply have the ability to slowly roll out features without the need
/// of an app update.
///
/// Requires the implementation of the [DynamicSettingsRepository] to be
/// provided to the options.
class DynamicSettingsUserStory extends StatefulWidget {
  /// Creates a Dynamic Settings Userstory
  const DynamicSettingsUserStory({
    required this.namespace,
    required this.options,
    this.onExit,
    super.key,
  });

  /// The domain namespace that identifies these settings.
  ///
  /// If used as settings on an internal
  final String namespace;

  ///
  final DynamicSettingsOptions options;

  ///
  final VoidCallback? onExit;

  @override
  State<DynamicSettingsUserStory> createState() =>
      _DynamicSettingsUserStoryState();
}

class _DynamicSettingsUserStoryState extends State<DynamicSettingsUserStory> {
  late DynamicSettingsService _settingsService = DynamicSettingsService(
    repository: widget.options.dynamicRepository,
  );

  late final PopHandler _popHandler = PopHandler();

  @override
  void didUpdateWidget(covariant DynamicSettingsUserStory oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options != oldWidget.options) {
      setState(() {
        _settingsService = DynamicSettingsService(
          repository: widget.options.dynamicRepository,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) => DynamicSettingsScope(
        options: widget.options,
        service: _settingsService,
        popHandler: _popHandler,
        child: DynamicSettingsScreen(
          namespace: widget.namespace,
        ),
      );
}

/// User story for managing settings per namespace.
///
/// This is the most common case for
class DynamicSettingsNamespaceAdminUserStory extends StatelessWidget {
  /// Create an admin flow for user stories for a specific namespace
  const DynamicSettingsNamespaceAdminUserStory({
    required this.namespace,
    super.key,
  });

  /// The currently selected namespace
  final String namespace;

  @override
  Widget build(BuildContext context) => const Placeholder();
}

/// User story for managing multiple namespaces
class DynamicSettingsAdminUserStory extends StatefulWidget {
  /// Create an admin flow for all namespaced settings
  const DynamicSettingsAdminUserStory({
    required this.options,
    this.onExit,
    super.key,
  });

  ///
  final DynamicSettingsOptions options;

  ///
  final VoidCallback? onExit;

  @override
  State<DynamicSettingsAdminUserStory> createState() =>
      _DynamicSettingsAdminUserStoryState();
}

class _DynamicSettingsAdminUserStoryState
    extends State<DynamicSettingsAdminUserStory> {
  late DynamicSettingsService _dynamicSettingsService = DynamicSettingsService(
    repository: widget.options.dynamicRepository,
  );

  late final PopHandler _popHandler = PopHandler();

  @override
  void didUpdateWidget(covariant DynamicSettingsAdminUserStory oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options != oldWidget.options) {
      setState(() {
        _dynamicSettingsService = DynamicSettingsService(
          repository: widget.options.dynamicRepository,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) => DynamicSettingsScope(
        options: widget.options,
        service: _dynamicSettingsService,
        popHandler: _popHandler,
        child: NavigatorPopHandler(
          onPop: _popHandler.handlePop,
          child: Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => DynamicSettingsAdminScreen(
                onExit: () => widget.onExit?.call(),
              ),
            ),
          ),
        ),
      );
}
