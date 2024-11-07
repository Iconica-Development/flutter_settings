import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:flutter_settings/src/config/controls/checkbox.dart";
import "package:flutter_settings/src/config/controls/date.dart";
import "package:flutter_settings/src/config/controls/dropdown.dart";
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
  static RadioControlConfig<T> radio<T>({
    required String key,
    required String title,
    required List<T> options,
    String? description,
    ControlWrapperBuilder<T, RadioControlConfig<T>>? wrapperBuilder,
  }) =>
      RadioControlConfig(
        title: title,
        description: description,
        options: options,
        initialValue: SettingsControl(key: key),
        wrapperBuilder: wrapperBuilder ?? defaultDescriptionTitleControlWrapper,
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
  }) =>
      TextControlConfig(
        title: title,
        description: description,
        hintText: hintText,
        validator: validator,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        maxLines: maxLines,
        initialValue: SettingsControl(key: key),
        wrapperBuilder: wrapperBuilder ?? defaultDescriptionTitleControlWrapper,
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
  }) =>
      DropdownControlConfig(
        title: title,
        description: description,
        hintText: hintText,
        options: options,
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
