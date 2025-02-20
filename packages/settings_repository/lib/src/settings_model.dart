/// A model representing a collection of settings.
///
/// This class provides functionality to store, retrieve, and merge settings.
class SettingsModel {
  /// Creates an instance of [SettingsModel] with the given [data].
  const SettingsModel({
    required this.data,
  });

  /// A map storing the settings as key-value pairs.
  final Map<String, dynamic> data;

  /// Sets a setting identified by [setting] with the given [value].
  void setSetting<T>(String setting, T value) {
    data[setting] = value;
  }

  /// Retrieves the value of a setting identified by [setting].
  ///
  /// Returns `null` if the setting does not exist or cannot be cast to
  /// type [T].
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

  /// Merges the current settings with a previous [SettingsModel].
  ///
  /// The resulting model contains all settings from both instances, with
  /// values in the current instance taking precedence.
  SettingsModel mergeWithPrevious(SettingsModel previous) => SettingsModel(
        data: {
          ...previous.data,
          ...data,
        },
      );
}
