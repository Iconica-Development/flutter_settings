import 'package:flutter/material.dart';
import 'package:flutter_settings/flutter_settings.dart';
import 'package:flutter_settings_repository/flutter_settings_repository.dart';

var controls = [
  MyCustomSetting(
    title: "Amazing",
    description: "Control",
    initialValue: SettingsControl(key: "my_custom_int"),
  ),
  SettingsControlConfig.page(
    title: "Wowy",
    children: [
      SettingsControlConfig.toggle(
        key: "my_toggle",
        title: "Wow, My toggle",
        description: "This is amazing",
      ),
      SettingsControlConfig.toggle(
        key: "my_toggle",
        title: "Wow, My toggle",
        description: "This is amazing",
      ),
      SettingsControlConfig.toggle(
        key: "my_toggle2",
        title: "Wow, My toggle",
        description: "This is amazing",
      ),
      MyCustomSetting(
        title: "Amazing",
        description: "Control",
        initialValue: SettingsControl(key: "my_custom_int"),
      ),
      SettingsControlConfig.page(
        title: "some subpage",
        children: [
          SettingsControlConfig.toggle(
            key: "my_toggle3",
            title: "Wow, My toggle",
            description: "This is amazing",
          ),
          SettingsControlConfig.toggle(
            key: "my_toggle",
            title: "Wow, My toggle",
            description: "This is amazing",
          ),
          SettingsControlConfig.toggle(
            key: "my_toggle5",
            title: "Wow, My toggle",
            description: "This is amazing",
          ),
        ],
      ),
    ],
  ),
  SettingsControlConfig.toggle(
    key: "home_toggle",
    title: "Show home",
    description: "Do you want to show home?",
  ),
  SettingsControlConfig.page(
    title: "Some page",
    children: [
      SettingsControlConfig.toggle(key: "page_toggle", title: "Wow"),
      SettingsControlConfig.group(
        title: "Some group",
        wrapperBuilder: (context, child, control, config) => Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.green,
          ),
          child: child,
        ),
        children: [
          SettingsControlConfig.toggle(
            key: "Another",
            title: "Another",
          ),
          SettingsControlConfig.toggle(
            key: "One",
            title: "One",
          ),
          SettingsControlConfig.group(
            title: "Hmm",
            wrapperBuilder: (context, child, control, config) => Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
              child: child,
            ),
            children: [
              SettingsControlConfig.page(
                title: "Test",
                children: [
                  SettingsControlConfig.toggle(
                    key: "test",
                    title: "Hello World",
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];

void main() {
  runApp(const MyApp());
}

class MyCustomSetting
    extends DescriptiveTitleControlConfig<int, MyCustomSetting> {
  MyCustomSetting({
    required super.title,
    required super.description,
    required super.initialValue,
    super.wrapperBuilder = defaultDescriptionTitleControlWrapper,
  }) : super();

  @override
  Widget buildSetting(
    BuildContext context,
    SettingsControl<int> control,
    SettingsControlController controller,
  ) {
    return Slider(
      max: 10,
      value: control.value?.toDouble() ?? 0.0,
      onChanged: (value) {
        controller.updateControl(control.update(value.toInt()));
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var settingsService = SettingsService(
      namespace: "1",
      repository: LocalSettingsRepository(),
    );

    return MaterialApp(
      home: Stack(
        children: [
          SettingsUserStory(
            options: SettingsOptions(
              controls: controls,
            ),
          ),
          Positioned(
            child: FloatingActionButton(
              child: StreamBuilder(
                stream: settingsService.getValue("my_custom_int", () => 0),
                builder: (context, snapshot) {
                  return Text("${snapshot.data}");
                },
              ),
              onPressed: () {
                settingsService.setValue("home_toggle", true);
              },
            ),
          ),
        ],
      ),
    );
  }
}
