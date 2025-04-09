/// The saving strategy for storing settings
///
/// The idea that sometimes a backend would have separate endpoints for
/// different settings. A different strategy can then be used to allow you to
/// save the various settings individually.
///
/// Do not use the [oncePerSetting] if there are only a few different
/// data-sources, instead use [HybridSettingsRepository]
enum SettingsSaveStrategy {
  /// Save all settings as one giant model
  allAtOnce,

  /// Save settings on a per setting basis
  oncePerSetting,
}
