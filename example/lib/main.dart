import 'package:flutter/material.dart';
import 'package:flutter_settings/flutter_settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: StartScreen(),
      ),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SizedBox.shrink(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const Settings(),
          ));
        },
        child: const Icon(Icons.start),
      ),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: DeviceSettingsPage(
              settings: [
                Control.group(
                  title: 'SUBPAGE',
                  settings: [
                    Control.page(
                      controls: pages,
                      title: 'Item 1',
                      description: "This is a description",
                      preficIcon: Icon(
                        Icons.person_outline,
                        size: 32,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Control.page(
                      controls: pages,
                      title: 'Setting name',
                      description: "This is a description",
                      preficIcon: Icon(
                        Icons.person_outline,
                        size: 32,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Control.page(
                      controls: pages,
                      title: 'Setting name',
                      preficIcon: Icon(
                        Icons.person_outline,
                        size: 32,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Control.group(
                  title: 'TOGGLE',
                  settings: [
                    Control.toggle(
                      value: false,
                      key: 'Settingsname',
                      title: 'Setting name',
                      description: "This is a description",
                    ),
                    Control.toggle(
                      value: true,
                      key: 'Settingsname1',
                      title: 'Setting name',
                    ),
                  ],
                ),
                Control.group(
                  title: 'CHECKBOX',
                  settings: [
                    Control.checkBox(
                      value: false,
                      key: 'Settingsnam2',
                      title: 'Setting name',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        size: 32,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Control.checkBox(
                      value: true,
                      key: 'Settingsname3',
                      title: 'Setting name',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        size: 32,
                        color: theme.colorScheme.primary,
                      ),
                      description: "This is a description",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}

List<Control> pages = [
  Control.toggle(
    key: 'settingsName5',
    title: 'Setting name',
    description: 'Description',
  ),
  Control.group(
    title: 'SECTION',
    settings: [
      Control.checkBox(
        value: false,
        key: 'Settingsnam8',
        title: 'Setting name',
        description: "This is a description",
      ),
      Control.checkBox(
        value: true,
        key: 'Settingsname7',
        title: 'Setting name',
        description: "This is a description",
      ),
    ],
  ),
];
