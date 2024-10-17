class SettingsModel {
  const SettingsModel({
    required this.data,
  });

  final Map<String, dynamic> data;

  void setSetting<T>(String setting, T value) {
    data[setting] = value;
  }

  T? getSetting<T>(String setting) {
    if (!data.containsKey(setting)) {
      return null;
    }

    var value = data[setting];

    if (value == null) {
      return value;
    }

    if (value is T) {
      return value;
    }

    return null;
  }

  SettingsModel mergeWithPrevious(SettingsModel previous) => SettingsModel(
        data: {
          ...previous.data,
          ...data,
        },
      );
}
