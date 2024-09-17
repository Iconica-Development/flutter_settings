import "package:flutter_settings/flutter_settings.dart";

void setValues(List<Control> settings, Map<String, dynamic> values) {
  for (var setting in settings)
    switch (setting.type) {
      case ControlType.group:
        setValues(setting.settings!, values);
      default:
        setting.value = values[setting.key] ?? setting.value;
    }
}
