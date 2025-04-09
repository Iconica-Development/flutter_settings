import "package:flutter/material.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:hybrid/settings.dart";

void main() {
  runApp(const HybridSettingsApp());
}

class HybridSettingsApp extends StatelessWidget {
  const HybridSettingsApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.dark(),
        home: const HomeScreen(),
      );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> openSettings() => openSettingsForNamespace(
        context,
        namespace: settingsNamespace,
        options: settingsOptions,
      );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: openSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Counter value:",
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              "$_counter",
              style: theme.textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }
}
