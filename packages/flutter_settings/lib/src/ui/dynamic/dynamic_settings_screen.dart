import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:flutter_settings/src/util/scope.dart";
import "package:settings_repository/settings_repository.dart";

/// A screen for dynamic settings
class DynamicSettingsScreen extends HookWidget {
  /// Create a dynamic settings screen
  const DynamicSettingsScreen({
    required this.namespace,
    super.key,
  });

  /// The current namespace in use.
  final String namespace;

  @override
  Widget build(BuildContext context) {
    var scope = DynamicSettingsScope.of(context);
    var stream = useMemoized(
      () => scope.service.getDynamicSettingsForNamespace(namespace),
      [namespace],
    );
    var snapshots = useStream(stream);

    if (snapshots.hasError) {
      return const CircularProgressIndicator();
    }

    if (snapshots.hasData) {
      var data = snapshots.data;

      assert(
        data != null,
        "The dynamic settings snapshot should always have data",
      );

      return _DynamicSettingsToControls(
        dynamicSettings: data!,
      );
    }

    return const CircularProgressIndicator();
  }
}

class _DynamicSettingsToControls extends HookWidget {
  const _DynamicSettingsToControls({
    required this.dynamicSettings,
  });

  final List<DynamicSetting> dynamicSettings;

  List<SettingsControlConfig> _createControls(
    List<DynamicSetting> dynamicSettings,
    DynamicSettingsOptions options,
    DynamicSettingsService service,
  ) {
    var settingMappings = options.mappings;

    SettingsControlConfig createConfigFromDynamicSetting(
      DynamicSetting setting,
    ) {
      var createdControls = _createControls(
        service.getChildrenForSetting(this.dynamicSettings, setting),
        options,
        service,
      );

      return settingMappings.createControl(
        setting,
        createdControls,
      );
    }

    return dynamicSettings
        .where(settingMappings.isSettingSupported)
        .map(createConfigFromDynamicSetting)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var scope = DynamicSettingsScope.of(context);

    var shouldRebuild = listEquals(
      dynamicSettings,
      usePrevious(dynamicSettings),
    );

    var controls = useMemoized<List<SettingsControlConfig>>(
      () => _createControls(dynamicSettings, scope.options, scope.service),
      [shouldRebuild],
    );

    return SettingsUserStory(
      options: SettingsOptions(
        controls: controls,
        baseScreenBuilder: scope.options.baseScreenBuilder,
        saveMode: scope.options.saveMode,
        primaryButtonBuilder: scope.options.primaryButtonBuilder,
        repository: scope.options.repository,
      ),
    );
  }
}
