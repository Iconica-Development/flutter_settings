# flutter_settings

This package creates an all encompassing implementation for handler settings related use-cases. By Default this package runs with a local data implementation that does not persist data. You can add your own implementation by implementing the SettingsRepository.

All configuration of the userstory is done through the SettingsOptions class.

> TODO: GIF

Figma Design that defines this component (only accessible for Iconica developers): TO BE CREATED
Figma clickable prototype that demonstrates this component (only accessible for Iconica developers): TO BE CREATED

## Setup

To use this package, add flutter_settings as a dependency in your pubspec.yaml file:

```
  flutter_settings:
    hosted: https://forgejo.internal.iconica.nl/api/packages/internal/pub
    version: {version}
```

You can start the userstory by adding the settings widget like this to your widget tree:

```dart
SettingsUserStory(
    namespace: "someNameSpace",
    options: SettingsOptions(),
),
```
There is also a function for pushing the settings screen to the navigation stack:

```dart
openAvailabilitiesForUser(context, namespace: "settingsNamespace", options: SettingsOptions(),);
```

## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/Iconica-Development/flutter_settings) page. Commercial support is available if you need help with integration with your app or services. You can contact us at [support@iconica.nl](mailto:support@iconica.nl).

## Want to contribute
[text](about:blank#blocked)
If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](./CONTRIBUTING.md) and send us your [pull request](https://github.com/Iconica-Development/flutter_settings/pulls).

## Author

This flutter_settings for Flutter is developed by [Iconica](https://iconica.nl). You can contact us at <support@iconica.nl>