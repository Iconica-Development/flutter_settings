import 'package:flutter/material.dart';
import 'package:flutter_settings/flutter_settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DeviceSettingsPage(
          settings: [Control.textField(key: 'test')],
        ),
      ),
    );
  }
}
