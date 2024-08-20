///
// ignore_for_file: avoid_annotating_with_dynamic

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_input_library/flutter_input_library.dart';

/// The settings are saved to shared preferences. Use the key you set to extract
/// the value of the settings.
///
/// prefs.getInt('KEY_HERE');
///
/// The types you need to extract the value of the ControlsTypes are:
/// DropDown int
/// Radio String
/// Checkbox String
/// String String
/// Number int
/// Toggle bool
/// Range double
/// TextField String
enum ControlType {
  dropDown,
  radio,
  checkBox,
  number,
  toggle,
  group,
  textField,
  page,
  date,
  time,
  dateRange,
  custom,
}

class Control extends ChangeNotifier {
  Control({
    required this.key,
    required this.type,
    this.content,
    this.onChange,
    this.settings,
    this.title,
    this.value,
    this.keyboardType,
    this.validator,
    this.isRequired = true,
    this.suffixIcon,
    this.formatInputs,
    this.decoration,
    this.maxLines,
    this.description,
    this.boxDecoration,
    this.prefixIcon,
    this.partOfGroup = false,
    this.isLastSettingInGroup = false,
    this.hintText,
    this.initialValue,
    this.onTap,
  });

  factory Control.custom({
    required String key,
    Widget? content,
  }) =>
      Control(
        key: key,
        type: ControlType.custom,
        content: content,
      );

  factory Control.page({
    required List<Control> controls,
    required String title,
    String? description,
    Icon? preficIcon,
    void Function()? onTap,
  }) =>
      Control(
        type: ControlType.page,
        key: 'page_$title',
        title: title,
        settings: controls,
        description: description,
        prefixIcon: preficIcon,
        onTap: onTap,
      );

  factory Control.radio({
    required List<RadioItem<String>> items,
    required String key,
    String? title,
    String? selected,
    void Function(dynamic)? onChange,
    String? description,
  }) =>
      Control(
        value: {'items': items, 'selected': selected},
        type: ControlType.radio,
        title: title,
        onChange: onChange,
        key: key,
        description: description,
      );

  factory Control.dropDown({
    required List<String> items,
    required String key,
    String? title,
    int? selected,
    void Function(Map<String, dynamic>)? onChange,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    String? description,
    String? hintText,
  }) {
    if (selected != null) {
      assert(selected < items.length, 'Selected exceeds item length');
      assert(selected >= 0, 'Selected must be a positive value');
    }
    return Control(
      value: {'items': items, 'selected': selected},
      type: ControlType.dropDown,
      title: title,
      onChange: (value) {
        onChange?.call(value);
      },
      key: key,
      suffixIcon: suffixIcon,
      validator: validator,
      description: description,
      hintText: hintText,
    );
  }

  factory Control.toggle({
    required String key,
    String? title,
    void Function(Map<String, dynamic>)? onChange,
    bool? value,
    String? description,
    Icon? prefixIcon,
    bool partOfGroup = false,
  }) =>
      Control(
        title: title ?? '',
        value: value ?? false,
        onChange: (value) {
          onChange?.call(value);
        },
        key: key,
        type: ControlType.toggle,
        description: description,
        prefixIcon: prefixIcon,
        partOfGroup: partOfGroup,
      );

  factory Control.checkBox({
    required String key,
    String? title,
    void Function(dynamic)? onChange,
    bool? value,
    Icon? prefixIcon,
    String? description,
    bool partOfGroup = false,
  }) =>
      Control(
        title: title ?? '',
        value: value ?? false,
        onChange: (value) {
          onChange?.call(value);
        },
        key: key,
        type: ControlType.checkBox,
        prefixIcon: prefixIcon,
        description: description,
        partOfGroup: partOfGroup,
      );

  factory Control.number({
    required String key,
    String? title,
    void Function(dynamic)? onChange,
    int? value,
    int? max,
    int? min,
  }) =>
      Control(
        title: title ?? '',
        onChange: (value) {
          onChange?.call(value);
        },
        key: key,
        type: ControlType.number,
        value: <String, int>{
          'selected': value ?? min ?? 0,
          'min': min ?? 0,
          'max': max ?? 10,
        },
      );

  factory Control.date({
    required String key,
    String? title,
    void Function(dynamic)? onChange,
    DateTime? value,
    DateTime? min,
    DateTime? max,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    String? description,
  }) =>
      Control(
        key: key,
        type: ControlType.date,
        title: title,
        onChange: (value) {
          onChange?.call(value);
        },
        value: <String, DateTime?>{
          'selected': value ?? DateTime.now(),
          'min': min ?? value ?? DateTime.now(),
          'max': max ??
              (min ?? value ?? DateTime.now()).add(
                const Duration(days: 365),
              ),
        },
        suffixIcon: suffixIcon,
        validator: validator,
        description: description,
      );

  factory Control.time({
    required String key,
    String? title,
    void Function(dynamic)? onChange,
    TimeOfDay? value,
    Widget? suffixIcon,
    String? description,
  }) =>
      Control(
        key: key,
        type: ControlType.time,
        title: title,
        onChange: (value) {
          onChange?.call(value);
        },
        value: value ?? TimeOfDay.now(),
        suffixIcon: suffixIcon,
        description: description,
      );

  factory Control.dateRange({
    required String key,
    String? title,
    void Function(dynamic)? onChange,
    DateTimeRange? value,
    DateTime? min,
    DateTime? max,
    Widget? suffixIcon,
    String? description,
  }) =>
      Control(
        key: key,
        type: ControlType.dateRange,
        title: title,
        onChange: (value) {
          onChange?.call(value);
        },
        value: <String, DateTime?>{
          'selected-start': value?.start ?? DateTime.now(),
          'selected-end':
              value?.end ?? DateTime.now().add(const Duration(days: 1)),
          'min': min ?? value?.start ?? DateTime.now(),
          'max': max ??
              (min ?? value?.start ?? DateTime.now())
                  .add(const Duration(days: 365)),
        },
        suffixIcon: suffixIcon,
        description: description,
      );

  factory Control.group({
    required List<Control> settings,
    String? title,
    BoxDecoration? boxDecoration,
  }) =>
      Control(
        type: ControlType.group,
        key: 'group_$title',
        settings: settings,
        title: title,
        boxDecoration: boxDecoration,
      );

  factory Control.textField({
    required String key,
    String? title,
    Widget? content,
    void Function(dynamic)? onChange,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
    bool isRequired = false,
    Widget? suffixIcon,
    List<TextInputFormatter>? formatInputs,
    InputDecoration? decoration,
    int? maxLines,
    String? description,
    String? hintText,
    String? initialValue,
  }) =>
      Control(
        title: title ?? '',
        type: ControlType.textField,
        key: key,
        content: content,
        onChange: (value) {
          onChange?.call(value);
        },
        initialValue: initialValue,
        keyboardType: keyboardType,
        validator: validator,
        isRequired: isRequired,
        formatInputs: formatInputs,
        decoration: decoration,
        suffixIcon: suffixIcon,
        maxLines: maxLines,
        description: description,
        hintText: hintText,
      );

  /// The value is the defaultvalue along with the items or options depending on
  /// whether the ControlType requires items or options to be given. If the
  /// ControlType is a bool the value should also be a bool. If the ControlsType
  /// is a DropDown the value should be a MapR containing the int selected and
  /// the items in the form of a List with Strings. If the ControlType is a
  /// Radio the value should be a Map containing int selected and List<String>
  /// options. If the ControlType is range the Map should contain max, min and
  /// selected. All three are doubles.
  dynamic value;

  /// This method is invoked everytime the user changes the setting
  void Function(Map<String, dynamic>)? onChange;

  /// The settings is a List containing the Controls that are shown grouped
  /// together inside a Container. The settings should only be used if the
  /// ControlType is Group.
  List<Control>? settings;

  /// The type is the type of Control. To see all the options see ControlType.
  ControlType type;

  /// The key is used to store the value in the shared preferences
  ///
  /// Hover over ControlsType to see how to extract the value from the shared
  /// preferences
  String key;

  /// The title is shown above the Control
  String? title;

  /// This is an optional param. You should either set content or other params
  /// but not both. If content is not null the content is shown instead of the
  /// ControlType.
  Widget? content;

  /// The keyboardType (used for textFields)
  TextInputType? keyboardType;

  /// Fields can be validated by one or multiple validators with custom error
  /// messages. (used for textFields)
  FormFieldValidator<String>? validator;

  /// Specify if the field is required when shown on registration pages
  ///
  /// (used for textFields)
  bool isRequired;

  /// The Widget that is shown on the left side of the input.
  Widget? suffixIcon;

  /// Input formatters to limit input.
  ///
  /// (used for textFields)
  List<TextInputFormatter>? formatInputs;

  /// The decoration of the input field
  InputDecoration? decoration;

  /// The maximum amount of lines the textfield should have
  int? maxLines;

  /// The description is shown below the title
  String? description;

  /// The decoration of the input
  BoxDecoration? boxDecoration;

  /// The icon that is shown on the left side of the input
  Icon? prefixIcon;

  /// If the Control is part of a group
  bool partOfGroup;

  /// If the Control is the last setting in a group
  bool isLastSettingInGroup;

  /// The hint text that is shown in the input field
  String? hintText;

  /// The initial value of the input field
  String? initialValue;

  void Function()? onTap;

  void change(value) {
    onChange?.call(value);
    notifyListeners();
  }

  dynamic getValue() {
    if (value is Map) {
      if ((value as Map).containsKey('selected-start') &&
          (value as Map).containsKey('selected-end')) {
        return <DateTime>[
          (value as Map)['selected-start'],
          (value as Map)['selected-end'],
        ];
      } else {
        return (value as Map)['selected'];
      }
    } else {
      return value;
    }
  }

  void clear() {
    if (value is Map) {
      if ((value as Map).containsKey('selected-start') &&
          (value as Map).containsKey('selected-end')) {
        (value as Map)['selected-start'] = null;
        (value as Map)['selected-end'] = null;
      } else {
        (value as Map)['selected'] = null;
      }
    } else {
      value = null;
    }
  }
}
