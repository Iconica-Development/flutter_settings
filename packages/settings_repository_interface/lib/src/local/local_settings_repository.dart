import "package:settings_repository_interface/src/interfaces/settings_repository_interface.dart";

/// The local settings repository
class LocalSettingsRepository implements SettingsRepositoryInterface {
  LocalSettingsRepository();

  Map<String, dynamic> settingsMap = {};

  @override
  Future<void> loadSettings() async {
    settingsMap.addAll(settingsMap);
  }

  @override
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    settingsMap.addAll(settings);
  }

  @override
  Map<String, dynamic> get settings => settingsMap;
}
