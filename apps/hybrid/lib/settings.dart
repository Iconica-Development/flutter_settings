import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_settings/flutter_settings.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:device_settings_repository/device_settings_repository.dart';

const settingsNamespace = "counter_settings";

final repository = HybridSettingsRepository(
  baseRepository: DeviceSettingsRepository(),
  alternateRepositories: [
    AlternateSettingsRepository(
      settingKeys: ["enable_counter_controls"],
      settingsRepository: LocalSettingsRepository(),
    ),
  ],
);

final settingsService = SettingsService(
  namespace: settingsNamespace,
  repository: repository,
);

var controls = <SettingsControlConfig>[
  ControlConfig.checkbox(
    key: "enable_counter_controls",
    title: "Enable Counter controls",
  ),
  ControlConfig.group(
    title: "Counter controls",
    dependencies: [
      ControlDependency(
        control: const SettingsControl<bool>(key: "enable_counter_controls"),
        builder: (context, child, control) {
          if (control.value ?? false) {
            return child;
          }
          return const SizedBox.shrink();
        },
      ),
    ],
    children: [
      ControlConfig.text(
        key: "counter_increment",
        title: "By how much to increment the counter",
        validator: _validatePositiveNumber,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        ],
      ),
      ControlConfig.text(
        key: "counter_decrement",
        title: "By how much to decrement the counter",
        validator: _validatePositiveNumber,
        keyboardType: const TextInputType.numberWithOptions(),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        ],
      ),
    ],
  ),
];

var settingsOptions = SettingsOptions(controls: controls);

String? _validatePositiveNumber(value) {
  if (value == null) {
    return null;
  }

  var number = int.tryParse(value);

  if (number == null || number < 1) {
    return "This needs to be a positive number above 1";
  }

  return null;
}
