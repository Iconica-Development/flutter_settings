import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:flutter_settings/src/services/set_values.dart";
import "package:flutter_settings/src/services/setting_to_map.dart";

class DeviceSettingsPage extends StatefulWidget {
  DeviceSettingsPage({
    required this.settings,
    settingsService,
    this.controlWrapper,
    this.groupWrapper,
    this.dismissKeyboardOnTap = true,
    this.onSave,
    this.theme,
    super.key,
  }) : settingsService = settingsService ?? SettingsService();

  final SettingsService settingsService;
  final List<Control> settings;
  final Widget Function(Widget child, Control setting)? controlWrapper;
  final Widget Function(Widget child, Control setting)? groupWrapper;
  final Future<void> Function(Map<String, dynamic> settings)? onSave;
  final bool dismissKeyboardOnTap;
  final ThemeData? theme;

  @override
  State<DeviceSettingsPage> createState() => _DeviceSettingsPageState();
}

class _DeviceSettingsPageState extends State<DeviceSettingsPage> {
  bool _isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(widget.settingsService.loadSettings());
      setValues(widget.settings, widget.settingsService.settings);
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    if (!_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        var settingsMap = settingToMap(widget.settings);
        unawaited(widget.settingsService.saveSettings(settingsMap));
        unawaited(widget.onSave?.call(settingsMap));
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        widget.settings.length,
        (index) => InputFieldGenerator(
          settingsService: widget.settingsService,
          settings: widget.settings,
          index: index,
          onUpdate: setState,
          controlWrapper: widget.controlWrapper,
          groupWrapper: widget.groupWrapper,
          dismissKeyboardOnTap: widget.dismissKeyboardOnTap,
        ),
      ),
    );
  }
}
