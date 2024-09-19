import "package:flutter_settings/flutter_settings.dart";

Map<String, dynamic> settingToMap(List<Control> settings) {
  var map = <String, dynamic>{};
  for (var element in settings) {
    if (!element.key.startsWith("page") && !element.key.startsWith("group")) {
      map[element.key] = element.value ?? element.initialValue;
    }
    if (element.key.startsWith("group") && element.settings != null) {
      map[element.key] = settingToMap(element.settings!);
    }
  }
  return map;
}
