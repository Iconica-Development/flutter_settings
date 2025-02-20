/// The saving strategy for storing settings
enum SettingsSaveStrategy {
  /// Save all settings as one giant model
  allAtOnce,

  /// Save settings on a per setting basis
  oncePerSetting,
}
