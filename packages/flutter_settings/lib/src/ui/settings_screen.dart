import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:flutter_settings/src/util/scope.dart";
import "package:settings_repository/settings_repository.dart";

///
class SettingsScreen extends HookWidget {
  ///
  const SettingsScreen({
    required this.controls,
    required this.options,
    required this.onExit,
    this.page,
    super.key,
  });

  ///
  final List<SettingsControlConfig> controls;

  ///
  final PageControlConfig? page;

  ///
  final SettingsOptions options;

  ///
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    var scope = SettingsScope.of(context);
    var settingsService = scope.service;
    var valueControls = controls.map((c) => c.initialValue).toList();

    useEffect(() {
      scope.popHandler.add(onExit);
      return () => scope.popHandler.remove(onExit);
    });

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

    Future<void> saveControl(SettingsControl control) async {
      await settingsService.saveControl(control);
    }

    Future<void> saveAllControls(List<SettingsControl> controls) async {
      await settingsService.saveControls(controls);
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

    useListenable(currentScreenController);

    var body = StreamBuilder<List<SettingsControl>>(
      stream: settingsService
          .getSettingsAsControls(valueControls)
          .map(currentScreenController.mapUncommittedControls),
      builder: (context, snapshot) {
        SettingsControl getControl(int index, SettingsControlConfig config) {
          if (!snapshot.hasData) {
            return config.initialValue;
          }

          return snapshot.data![index];
        }

        return CustomScrollView(
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
                      snapshot.hasData
                          ? () async {
                              if (snapshot.hasData) {
                                await currentScreenController.commit(
                                  snapshot.data!,
                                );
                              }
                            }
                          : null,
                      const Text("Save"),
                    ),
                    const SizedBox(height: 40),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );

    return options.baseScreenBuilder(
      context,
      onExit,
      body,
    );
  }
}
