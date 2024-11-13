import "package:flutter/material.dart";
import "package:flutter_settings/src/config/controls/controls.dart";
import "package:settings_repository/settings_repository.dart";

///
Widget defaultTitleControlWrapper(
  BuildContext context,
  Widget child,
  SettingsControl control,
  TitleControlConfig config,
) {
  var theme = Theme.of(context);
  return Row(
    children: [
      Text(
        config.title,
        style: theme.textTheme.titleMedium,
      ),
      const SizedBox(height: 8.0),
      child,
    ],
  );
}

///
Widget defaultDescriptionTitleControlWrapper(
  BuildContext context,
  Widget child,
  SettingsControl control,
  DescriptiveTitleControlConfig config,
) {
  var theme = Theme.of(context);
  return DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(
        color: theme.colorScheme.outline,
      ),
      color: theme.colorScheme.secondaryContainer,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 16.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.title,
                  style: theme.textTheme.titleMedium,
                ),
                if (config.description != null) ...[
                  Text(
                    config.description!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          child,
        ],
      ),
    ),
  );
}

///
Widget defaultGroupControlWrapper(
  BuildContext context,
  Widget child,
  SettingsControl control,
  GroupControlConfig config,
) {
  var theme = Theme.of(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.only(
          left: 24.0,
          top: 24.0,
          right: 24.0,
          bottom: 8.0,
        ),
        child: Text(
          config.title,
          style: theme.textTheme.titleLarge,
        ),
      ),
      child,
    ],
  );
}
