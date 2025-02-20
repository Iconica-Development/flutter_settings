import "package:settings_repository/src/settings_model.dart";

/// A repository interface for managing settings storage and retrieval.
///
/// This interface defines methods for fetching, saving, and deleting settings
/// within a specified namespace.
abstract interface class SettingsRepository {
  /// Retrieves settings for a given [namespace] as a stream.
  ///
  /// The stream emits updates whenever settings within the namespace change.
  Stream<SettingsModel> getSettingsForNamespace(
    String namespace,
  );

  /// Saves the provided [model] as the settings for the given [namespace].
  Future<void> saveSettingsForNamespace(
    String namespace,
    SettingsModel model,
  );

  /// Saves a single setting identified by [setting] with the given [value]
  /// within the specified [namespace].
  Future<void> saveSingleSettingForNamespace<T>(
    String namespace,
    String setting,
    T value,
  );

  /// Retrieves the settings for a given [namespace] as a future.
  ///
  /// Unlike [getSettingsForNamespace], this returns the settings as a one-time
  /// future rather than a stream.
  Future<SettingsModel> getSettingsAsFuture<T>(
    String namespace,
  );

  /// Deletes all settings within the specified [namespace].
  Future<void> deleteNamespace(
    String namespace,
  );

  /// Deletes a specific setting identified by [setting] within the
  /// given [namespace].
  Future<void> deleteSettingForNamespace(
    String namespace,
    String setting,
  );
}
