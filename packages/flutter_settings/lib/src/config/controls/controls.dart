import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:flutter_settings/src/config/controls/checkbox.dart";
import "package:flutter_settings/src/config/controls/date.dart";
import "package:flutter_settings/src/config/controls/dropdown.dart";
import "package:flutter_settings/src/config/controls/radio.dart";
import "package:flutter_settings/src/config/controls/time.dart";
import "package:intl/intl.dart";
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
    List<SettingsDependency> dependencies = const [],
  }) =>
      CheckBoxControlConfig(
        title: title,
        description: description,
        initialValue: SettingsControl(key: key),
        wrapperBuilder: wrapperBuilder ?? defaultDescriptionTitleControlWrapper,
        dependencies: dependencies,
      );

  ///
  static RadioControlConfig<T> radio<T>({
    required String key,
    required String title,
    required List<T> options,
    String? description,
    ControlWrapperBuilder<T, RadioControlConfig<T>>? wrapperBuilder,
    List<SettingsDependency> dependencies = const [],
  }) =>
      RadioControlConfig(
        title: title,
        description: description,
        options: options,
        initialValue: SettingsControl(key: key),
        wrapperBuilder: wrapperBuilder ?? defaultDescriptionTitleControlWrapper,
        dependencies: dependencies,
      );

  ///
  static DateControlConfig date({
    required String key,
    required String title,
    String? description,
    String? hintText,
    String? dateFormat,
    double? maxwidth,
    Widget? suffixIcon,
    DateTime? firstDate,
    DateTime? lastDate,
    InputDecoration? inputDecoration,
    ControlWrapperBuilder<String, DateControlConfig>? wrapperBuilder,
    List<SettingsDependency> dependencies = const [],
  }) =>
      DateControlConfig(
        title: title,
        description: description,
        hintText: hintText,
        suffixIcon: suffixIcon,
        dateFormat: dateFormat,
        maxwidth: maxwidth,
        firstDate: firstDate,
        lastDate: lastDate,
        inputDecoration: inputDecoration,
        initialValue: SettingsControl(key: key),
        wrapperBuilder: wrapperBuilder ?? defaultDescriptionTitleControlWrapper,
        dependencies: dependencies,
      );

  ///
  static TextControlConfig text({
    required String key,
    required String title,
    String? description,
    String? hintText,
    InputDecoration? decoration,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    ControlWrapperBuilder<String, TextControlConfig>? wrapperBuilder,
    List<SettingsDependency> dependencies = const [],
  }) =>
      TextControlConfig(
        title: title,
        description: description,
        hintText: hintText,
        validator: validator,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        maxLines: maxLines,
        initialValue: SettingsControl(
          key: key,
          dependencies: dependencies.getControlDependencies(),
        ),
        wrapperBuilder: wrapperBuilder ?? defaultDescriptionTitleControlWrapper,
        dependencies: dependencies,
      );

  ///
  static DropdownControlConfig dropdown({
    required String key,
    required String title,
    required List<String> options,
    String? description,
    String? hintText,
    Widget? suffixIcon,
    InputDecoration? inputDecoration,
    ControlWrapperBuilder<String, DropdownControlConfig>? wrapperBuilder,
    List<SettingsDependency> dependencies = const [],
  }) =>
      DropdownControlConfig(
        title: title,
        description: description,
        hintText: hintText,
        options: options,
        initialValue: SettingsControl(
          key: key,
          dependencies: dependencies.getControlDependencies(),
        ),
        wrapperBuilder: wrapperBuilder ?? defaultDescriptionTitleControlWrapper,
      );

  ///
  static TimeControlConfig time({
    required String key,
    required String title,
    String? description,
    String? hintText,
    DateFormat? timeFormat,
    Widget? suffixIcon,
    InputDecoration? inputDecoration,
    ControlWrapperBuilder<String, TimeControlConfig>? wrapperBuilder,
    List<SettingsDependency> dependencies = const [],
  }) =>
      TimeControlConfig(
        title: title,
        description: description,
        hintText: hintText,
        timeFormat: timeFormat,
        suffixIcon: suffixIcon,
        initialValue: SettingsControl(
          key: key,
          dependencies: dependencies.getControlDependencies(),
        ),
        wrapperBuilder: wrapperBuilder ?? defaultDescriptionTitleControlWrapper,
        dependencies: dependencies,
      );

  ///
  static SettingsControlConfig toggle({
    required String key,
    required String title,
    String? description,
    ControlWrapperBuilder<bool, ToggleControlConfig>? wrapperBuilder,
    List<SettingsDependency> dependencies = const [],
  }) =>
      ToggleControlConfig(
        title: title,
        description: description,
        initialValue: SettingsControl(
          key: key,
          dependencies: dependencies.getControlDependencies(),
        ),
        wrapperBuilder: wrapperBuilder ?? defaultDescriptionTitleControlWrapper,
        dependencies: dependencies,
      );

  ///
  static PageControlConfig page({
    required String title,
    required List<SettingsControlConfig> children,
    ControlWrapperBuilder<Never, PageControlConfig>? wrapperBuilder,
    String? description,
    List<SettingsDependency> dependencies = const [],
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
      initialValue: SettingsControl(
        key: null,
        children: innerControls,
        dependencies: dependencies.getControlDependencies(),
      ),
      wrapperBuilder: wrapperBuilder ?? defaultDescriptionTitleControlWrapper,
      dependencies: dependencies,
    );
  }

  ///
  static GroupControlConfig group({
    required String title,
    required List<SettingsControlConfig> children,
    ControlWrapperBuilder<Never, GroupControlConfig>? wrapperBuilder,
    String? description,
    List<SettingsDependency> dependencies = const [],
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
      initialValue: SettingsControl(
        key: null,
        children: innerControls,
        dependencies: dependencies.getControlDependencies(),
      ),
      wrapperBuilder: wrapperBuilder ?? defaultGroupControlWrapper,
      dependencies: dependencies,
    );
  }
}
