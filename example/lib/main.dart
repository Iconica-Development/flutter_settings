import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(border: Border.all()),
                child: DeviceSettingsPage(
                  settings: [
                    Control.dropDown(
                      key: 'dropdown',
                      items: ['Item1', 'Item2', 'Item3'],
                      title: 'Dropdown',
                      description: 'Dropdown description',
                      prefixIcon: const Icon(Icons.settings),
                    ),
                    Control.radio(
                      key: 'dropdown',
                      items: [
                        const RadioItem<String>(
                          value: 'Item1',
                          child: Text('item1'),
                        ),
                        const RadioItem<String>(
                          value: 'Item2',
                          child: Text('item2'),
                        ),
                        const RadioItem<String>(
                          value: 'Item3',
                          child: Text('item3'),
                        ),
                      ],
                      title: 'Dropdown',
                      description: 'Dropdown description',
                      prefixIcon: const Icon(Icons.settings),
                    ),
                    Control.number(
                      key: 'number',
                      title: 'Number',
                      description: 'Number description',
                      prefixIcon: const Icon(Icons.settings),
                    ),
                    Control.textField(
                      key: 'textfield',
                      title: 'Textfield',
                      description: 'Textfield description',
                      prefixIcon: const Icon(Icons.settings),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Field can't be empty";
                        }

                        return null;
                      },
                    ),
                    Control.textField(
                      key: 'numberfield',
                      title: 'Numberfield',
                      prefixIcon: const Icon(Icons.settings),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Field can't be empty";
                        }

                        return null;
                      },
                      keyboardType: TextInputType.number,
                      formatInputs: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    Control.page(
                      controls: [
                        Control.toggle(
                          key: 'toggle',
                          title: 'Toggle',
                          prefixIcon: const Icon(Icons.settings),
                        ),
                        Control.checkBox(
                          key: 'checkbox',
                          title: 'Checkbox',
                          prefixIcon: const Icon(Icons.settings),
                        ),
                      ],
                      title: 'Bool page',
                    ),
                    Control.group(
                      title: 'Group title',
                      settings: [
                        Control.date(
                          key: 'date',
                          min: DateTime.now().subtract(
                            const Duration(days: 365),
                          ),
                          max: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          value: DateTime.now(),
                          title: 'Date',
                          prefixIcon: const Icon(Icons.settings),
                        ),
                        Control.time(
                          key: 'time',
                          value: TimeOfDay.now(),
                          title: 'Time',
                          description: 'Time description',
                          prefixIcon: const Icon(Icons.settings),
                        ),
                        Control.dateRange(
                          key: 'dateRange',
                          title: 'Date range',
                          prefixIcon: const Icon(Icons.settings),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
