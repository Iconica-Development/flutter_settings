/// Functionality to save settings based on provided controls
///
/// Best used in combination with the flutter_settings user story.
///
/// You can find implementation for the settings_repository below:
/// - firebase_settings_repository - provides a link to firebase
/// - device_settings_repository - provides a shared preference implementation
library settings_repository;

export "src/controls.dart";
export "src/hybrid_settings_repository.dart";
export "src/local_settings_repository.dart";
export "src/save_mode.dart";
export "src/settings_model.dart";
export "src/settings_repository.dart";
export "src/settings_service.dart";
