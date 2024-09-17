import "package:settings_repository_interface/src/interfaces/settings_repository_interface.dart";
import "package:settings_repository_interface/src/local/local_settings_repository.dart";

class SettingsService {
  SettingsService({
    SettingsRepositoryInterface? settingsRepository,
  }) : settingsRepository = settingsRepository ?? LocalSettingsRepository();

  final SettingsRepositoryInterface settingsRepository;

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await settingsRepository.saveSettings(settings);
  }

  Future<void> loadSettings() async {
    await settingsRepository.loadSettings();
  }

  Map<String, dynamic> get settings => settingsRepository.settings;
}
