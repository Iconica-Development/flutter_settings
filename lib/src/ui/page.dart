import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_settings/flutter_settings.dart';
import 'package:flutter_settings/src/ui/control.dart';
import 'package:flutter_settings/src/ui/input_field_generator.dart';

abstract class SettingsPage extends StatefulWidget {
  const SettingsPage({
    required this.settings,
    super.key,
  });

  factory SettingsPage.profile(List<Control> settings) =>
      ProfileSettingsPage(settings: settings);

  factory SettingsPage.device({
    required List<Control> settings,
    bool loadFromPrefs = true,
    Function? onSave,
    bool saveToPrefs = true,
    ThemeData? theme,
  }) =>
      DeviceSettingsPage(
        settings: settings,
        onSave: onSave,
        saveToPrefs: saveToPrefs,
        loadFromPrefs: loadFromPrefs,
        theme: theme,
      );

  final List<Control> settings;
}

abstract class SettingsPageState<SP extends SettingsPage> extends State<SP> {
  bool _isLoading = true;

  Future<bool> saveSettings();

  Future<bool> loadSettings();

  @override
  void dispose() {
    if (!_isLoading) {
      unawaited(saveSettings());
    }
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadSettings();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      margin: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          widget.settings.length,
          (index) => InputFieldGenerator(
            settings: widget.settings,
            index: index,
            onUpdate: setState,
          ),
        ),
      ),
    );
  }
}
