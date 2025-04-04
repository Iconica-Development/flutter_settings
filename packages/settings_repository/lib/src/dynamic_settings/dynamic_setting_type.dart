class DynamicSettingType {
  DynamicSettingType({
    required this.type,
    required this.settingProperties,
  });

  final String type;
  final List<SettingProperty> settingProperties;
}

class SettingProperty {
  SettingProperty({
    required this.propertyType,
    required this.propertyName,
    required this.isRequired,
    this.defaultValue,
    this.options = const [],
  });

  final String propertyName;
  final bool isRequired;
  final dynamic defaultValue;
  final List<dynamic> options;
  final SettingPropertyType propertyType;
}

enum SettingPropertyType {
  string(_validateString),
  integer(_validateInteger),
  decimal(_validateDecimal),
  boolean(_validateBool);

  const SettingPropertyType(this.validate);

  static bool _validateString(value) => value is String;
  static bool _validateInteger(value) => value is int;
  static bool _validateDecimal(value) => value is double;
  static bool _validateBool(value) => value is bool;

  // ignore: avoid_annotating_with_dynamic
  final bool Function(dynamic value) validate;
}
