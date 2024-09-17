/// The settings repository interface
/// Implement this interface to create a settings
/// repository with a given data source.
abstract class SettingsRepositoryInterface {
  /// save settings
  Future<void> saveSettings(Map<String, dynamic> settings);

  /// load settings
  Future<void> loadSettings();

  /// get settings
  Map<String, dynamic> get settings;
}
