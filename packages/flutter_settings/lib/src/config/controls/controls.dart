import "package:flutter_settings/flutter_settings.dart";
import "package:flutter_settings/src/config/controls/checkbox.dart";
import "package:flutter_settings/src/config/controls/radio.dart";
import "package:settings_repository/settings_repository.dart";

export "base.dart";
export "group.dart";
export "page.dart";
export "text.dart";
export "toggle.dart";

// Ignored because we want to have a shorthand for quick access.
// ignore: avoid_classes_with_only_static_members
/// A shorthand for all available controls
abstract final class ControlConfig {
  ///
  static CheckBoxControlConfig checkbox({
    required String key,
    required String title,
    String? description,
    ControlWrapperBuilder<bool, CheckBoxControlConfig>? wrapperBuilder,
  }) =>
      CheckBoxControlConfig(
        title: title,
        description: description,
        initialValue: SettingsControl(key: key),
        wrapperBuilder: wrapperBuilder ?? defaultDescriptionTitleControlWrapper,
      );

  ///
  static SettingsControlConfig toggle({
    required String key,
    required String title,
    String? description,
    ControlWrapperBuilder<bool, ToggleControlConfig>? wrapperBuilder,
  }) =>
      ToggleControlConfig(
        title: title,
        description: description,
        initialValue: SettingsControl(key: key),
        wrapperBuilder: wrapperBuilder ?? defaultDescriptionTitleControlWrapper,
      );

  ///
  static PageControlConfig page({
    required String title,
    required List<SettingsControlConfig> children,
    ControlWrapperBuilder<Never, PageControlConfig>? wrapperBuilder,
    String? description,
  }) {
    assert(
      children.isNotEmpty,
      "You cannot create a page setting without providing at least 1 child.",
    );
    var innerControls = children.map((child) => child.initialValue).toList();

    return PageControlConfig(
      children: children,
      title: title,
      description: description,
      initialValue: SettingsControl(key: null, children: innerControls),
      wrapperBuilder: wrapperBuilder ?? defaultDescriptionTitleControlWrapper,
    );
  }

  ///
  static GroupControlConfig group({
    required String title,
    required List<SettingsControlConfig> children,
    ControlWrapperBuilder<Never, GroupControlConfig>? wrapperBuilder,
    String? description,
  }) {
    assert(
      children.isNotEmpty,
      "You cannot create a group setting without providing at least 1 child.",
    );
    var innerControls = children.map((child) => child.initialValue).toList();

    return GroupControlConfig(
      description: description,
      children: children,
      title: title,
      initialValue: SettingsControl(key: null, children: innerControls),
      wrapperBuilder: wrapperBuilder ?? defaultGroupControlWrapper,
    );
  }
}
