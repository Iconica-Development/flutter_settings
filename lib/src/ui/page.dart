import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_settings/flutter_settings.dart';
import 'package:flutter_settings/src/ui/input_field_generator.dart';

abstract class SettingsPage extends StatefulWidget {
  const SettingsPage({
    required this.settings,
    this.controlWrapper,
    this.groupWrapper,
    super.key,
  });

  factory SettingsPage.device({
    required List<Control> settings,
    Widget Function(Widget child, Control setting, {bool partOfGroup})?
        controlWrapper,
    Widget Function(Widget child, Control setting)? groupWrapper,
    bool loadFromPrefs = true,
    Future<void> Function(List<Control>)? onSave,
    bool saveToPrefs = true,
    ThemeData? theme,
  }) =>
      DeviceSettingsPage(
        settings: settings,
        controlWrapper: controlWrapper,
        groupWrapper: groupWrapper,
        onSave: onSave,
        saveToPrefs: saveToPrefs,
        loadFromPrefs: loadFromPrefs,
        theme: theme,
      );

  final List<Control> settings;
  final Widget Function(Widget child, Control setting, {bool partOfGroup})?
      controlWrapper;
  final Widget Function(Widget child, Control setting)? groupWrapper;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        widget.settings.length,
        (index) => InputFieldGenerator(
          settings: widget.settings,
          index: index,
          onUpdate: setState,
          controlWrapper: widget.controlWrapper,
          groupWrapper: widget.groupWrapper,
        ),
      ),
    );
  }
}
