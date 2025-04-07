import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:flutter_settings/src/util/scope.dart";
import "package:settings_repository/settings_repository.dart";

/// The base screen for a setting
class SettingsScreen extends HookWidget {
  /// Create a basic settings screen
  const SettingsScreen({
    required this.controls,
    required this.options,
    required this.onExit,
    this.page,
    super.key,
  });

  /// The current set of controls that are being displayed.
  final List<SettingsControlConfig> controls;

  /// The currently set page control.
  ///
  /// If it is null this is assumed to be the root page
  final PageControlConfig? page;

  /// The options on which this screen is built.
  final SettingsOptions options;

  /// Callback called when the user intends to leave the screen/
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var scope = SettingsScope.of(context);
    var settingsService = scope.service;
    var valueControls = controls.map((c) => c.initialValue).toList();

    Future<void> moveToPage(PageControlConfig config) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SettingsScreen(
            controls: config.children,
            options: options,
            page: config,
            onExit: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }

    var isSaving = useValueNotifier(false);

    Future<void> saveControl(SettingsControl control) async {
      await settingsService.saveControl(control);
    }

    Future<void> saveAllControls(List<SettingsControl> controls) async {
      isSaving.value = true;
      try {
        await settingsService.saveControls(controls);
      } finally {
        isSaving.value = false;
      }
    }

    var currentScreenController = useMemoized(
      () => SettingsControlController(
        onMoveToPage: moveToPage,
        onUpdateControl: saveControl,
        autoCommit: options.saveMode == SettingsSaveMode.onChanged,
        onUpdateAllControls: saveAllControls,
      ),
      [options, settingsService],
    );

    var settingsAsControlsStream = useMemoized(
      () => settingsService.getSettingsAsControls(valueControls),
      [valueControls],
    );

    var controlSnapshot = useStream(
      settingsAsControlsStream
          .map(currentScreenController.mapUncommittedControls),
    );

    Future<void> onExit() async {
      if (options.saveMode == SettingsSaveMode.onExitPage &&
          controlSnapshot.hasData) {
        await saveAllControls(controlSnapshot.data!);
      }

      this.onExit();
    }

    useEffect(() {
      scope.popHandler.add(onExit);
      return () => scope.popHandler.remove(onExit);
    });

    useListenable(currentScreenController);

    Future<void> saveControls() async {
      if (!controlSnapshot.hasData) {
        return;
      }

      await currentScreenController.commit(controlSnapshot.data!);
    }

    SettingsControl getControl(int index, SettingsControlConfig config) {
      if (!controlSnapshot.hasData) {
        return config.initialValue;
      }

      return controlSnapshot.data![index];
    }

    var isLoading = !controlSnapshot.hasData;

    var loadingOverlay = ColoredBox(
      color: theme.colorScheme.surface.withOpacity(0.6),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );

    var controlList = CustomScrollView(
      slivers: [
        SliverList.list(
          children: [
            for (var (index, control) in controls.indexed) ...[
              control.build(
                context,
                getControl(index, control),
                currentScreenController,
              ),
            ],
          ],
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          fillOverscroll: false,
          child: Column(
            children: [
              if (options.saveMode == SettingsSaveMode.button) ...[
                const SizedBox(height: 40),
                const Spacer(),
                options.primaryButtonBuilder(
                  context,
                  controlSnapshot.hasData ? saveControls : null,
                  const Text("Save"),
                ),
                const SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ],
    );

    var body = Stack(
      children: [
        Positioned.fill(
          child: controlList,
        ),
        Positioned.fill(
          child: HookBuilder(
            builder: (context) {
              useListenable(isSaving);

              var isVisible = isSaving.value || isLoading;

              return Visibility(
                visible: isVisible,
                child: loadingOverlay,
              );
            },
          ),
        ),
      ],
    );
    return options.baseScreenBuilder(
      context,
      onExit,
      body,
    );
  }
}
