import 'package:flutter/material.dart';
import 'package:flutter_settings/flutter_settings.dart';
import 'package:flutter_settings_repository/flutter_settings_repository.dart';

var controls = [
  SettingsControlConfig.group(
    title: "Custom Sliders",
    children: [
      MyCustomSetting(
        title: "Title",
        description: "My description",
        initialValue: SettingsControl(key: "int_slider_1"),
      ),
      MyCustomSetting(
        title: "Title",
        description: "My description",
        initialValue: SettingsControl(key: "int_slider_2"),
      ),
    ],
  ),
  SettingsControlConfig.group(
    title: "Toggles",
    children: [
      SettingsControlConfig.toggle(
        key: "test_1",
        title: "My Toggle",
        description: "Described",
      ),
      SettingsControlConfig.toggle(
        key: "test_2",
        title: "My Toggle",
        description: "Described",
      ),
    ],
  ),
  SettingsControlConfig.group(
    title: "Pages",
    children: [
      SettingsControlConfig.page(
        title: "My Toggle",
        description: "A subpage with several toggles",
        children: [
          SettingsControlConfig.group(
            title: "Toggles",
            children: [
              SettingsControlConfig.toggle(
                key: "test_1",
                title: "My Toggle",
                description: "Described",
              ),
              SettingsControlConfig.toggle(
                key: "test_2",
                title: "My Toggle",
                description: "Described",
              ),
            ],
          ),
        ],
      ),
      SettingsControlConfig.page(
        title: "My subpage",
        description: "A subpage of other toggles",
        children: [
          SettingsControlConfig.toggle(
            key: "test_2",
            title: "My Other Toggle",
            description: "Described",
          ),
          SettingsControlConfig.toggle(
            key: "test_1",
            title: "My Toggle on another page",
            description: "Described",
          ),
        ],
      )
    ],
  ),
];

void main(List<String> args) {
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
            bottom: 16,
            right: 16,
            child: StreamBuilder(
              stream: settingsService.getValue<int>("int_slider_1", () => 0),
              builder: (context, snapshot) => FloatingActionButton(
                child: Text("${snapshot.data}"),
                onPressed: () {
                  settingsService.setValue("test_1", true);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
