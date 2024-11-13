# Flutter Settings
`flutter_settings` is an easy to use and implement settings package for Flutter applications.
![Settings GIF](flutter_settings.gif)

## Table of Contents
- [Terminology](#terminology)
- [Setup](#setup)
- [How to use](#how-to-use)
- [Issues](#issues)
- [Want to contribute](#want-to-contribute)
- [Author](#author)

## Terminology
| Term       | Description                            |
|------------|----------------------------------------|
| Package    | This GitHub Repository                 |
| Control    | A Type of field in a form              |
| Repository | An interface that is used to manipulate stored data |

## Setup
To use this package, add flutter_settings as a dependency in your pubspec.yaml file:
```yaml
flutter_settings:
    hosted: https://forgejo.internal.iconica.nl/api/packages/internal/pub
    version: 6.0.1
```

You can use `DeviceSettingsPage` to test the package in your project, this is also your entry point into this package:
```dart
DeviceSettingsPage(
    settings: const <Control>[],
);
```

To use a custom repository you can extend `SettingsRepositoryInterface` and implement it, like so:
```dart
DeviceSettingsPage(
    settings: const <Control>[],
    settingsService: SettingsService(
        settingsRepository: CustomSettingsRepository(),
    ),
);
```

Create a Firebase project for your application and add firebase firestore and storage.
Make sure you are authenticated using the Firebase_auth package or adjust your firebase rules, otherwise you won't be able to retrieve data.
You can find out more about this subject on [Get started with Firebase](https://firebase.google.com/docs/flutter/setup).

There is a predefined SettingsRepository for Firebase called `FirebaseSettingsRepository`.
If this does not include the desired functionality you can extend `SettingsRepositoryInterface`.
To use this repository do the same steps for a custom repository, like this:
```dart
DeviceSettingsPage(
    settings: const <Control>[],
    settingsService: SettingsService(
        settingsRepository: FirebaseSettingsRepository(),
    ),
);
```

If you use the predefined `FirebaseSettingsRepository`.
You need to create a collection called `users` with a document called `settings`.

## How to use
These are the current control types that can be used, these can be retrieved from `ControlType`:
|Control|ValueType|Explanation|
|---------|--------|------------|
|DropDown|int| - |
|Radio|String| - |
|Checkbox|String| - |
|Number|int| - |
|Toggle|bool| - |
|Range|double| - |
|TextField|String| - |
|Date|DateTime| - |
|Time|TimeOfDay| - |
|DateRange|DateTimeRange| - |
|Group| - |Can have other controls in itself using its `settings` property|
|Custom| - |Can have a custom widget using its `content` property|
|Page| - |Can have other controls in itself using its `controls` property, it also has a required `title` property|

At the moment the `Control` cannot be extended to add a new control factory.
However the `factory Control.custom` can be used to implement any custom control for your own project, like so:
```dart
Control.custom(
    key: UniqueKey().toString(),
    content: Card(
        child: InkWell(
            onTap: () { /* on tap functionality */},
            child: const Text("Custom"),
        ),
    ),
),
```
At the moment there isn't an easy way to configure the `Control.custom` or store the value from `Control.custom` in a repository.

To add additional functionality a callback can be given to `DeviceSettingsPage.onSave`, this callback will be executed after saving the Control values using the repository save function.

To dismiss the keyboard when the user taps outside of the keyboard `dismissKeyboardOnTap` can be set.
This is only used for textfields.

To use a custom control builder you can use `DeviceSettingsPage.controlWrapper`.
If this property is given then it will be used for every control.

To use a custom group builder you can use `DeviceSettingsPage.groupWrapper`.
If this property is given then it will be used for every group.

> At the moment `DeviceSettingsPage.theme` isn't being used.

## Issues
Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/Iconica-Development/flutter_settings/pulls) page. Commercial support is available if you need help with integration with your app or services. You can contact us at [support@iconica.nl](mailto:support@iconica.nl).

## Want to contribute
If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](../CONTRIBUTING.md) and send us your [pull request](https://github.com/Iconica-Development/flutter_settings/pulls).

## Author
This `flutter_settings` for Flutter is developed by [Iconica](https://iconica.nl). You can contact us at <support@iconica.nl>
