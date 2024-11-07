import 'package:device_settings_repository/device_settings_repository.dart';
import 'package:example/my_image_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings/flutter_settings.dart';
import 'package:settings_repository/settings_repository.dart';

final sharedPreferencesRepository = DeviceSettingsRepository();

var settingControls = <SettingsControlConfig>[
  ControlConfig.group(
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
      MyImageControl(key: "my_image", title: "Mikey"),
    ],
  ),
  ControlConfig.group(
    title: "Toggles",
    children: [
      ControlConfig.toggle(
        key: "test_1",
        title: "My Toggle",
        description: "Described",
      ),
      TextControlConfig(
        title: "Hello World",
        key: "text_key_1",
      ),
      ControlConfig.toggle(
        key: "test_2",
        title: "My Toggle",
        description: "Described",
      ),
    ],
  ),
  ControlConfig.group(
    title: "Radio Options",
    children: [
      ControlConfig.radio(
        key: "radio_1",
        title: "My Radio",
        description: "Described",
        options: ["Light", "Dark", "Adaptive"],
      ),
      ControlConfig.radio(
        key: "radio_2",
        title: "My Radio",
        description: "Described",
        options: ["Small", "Medium", "Large", "Extra Large"],
      ),
    ],
  ),
  ControlConfig.group(
    title: "Pages",
    children: [
      ControlConfig.page(
        title: "My Toggle",
        description: "A subpage with several toggles",
        children: [
          ControlConfig.group(
            title: "Toggles",
            children: [
              ControlConfig.toggle(
                key: "test_1",
                title: "My Toggle",
                description: "Described",
              ),
              ControlConfig.toggle(
                key: "test_2",
                title: "My Toggle",
                description: "Described",
              ),
            ],
          ),
        ],
      ),
      ControlConfig.page(
        title: "My subpage",
        description: "A subpage of other toggles",
        children: [
          ControlConfig.toggle(
            key: "test_2",
            title: "My Other Toggle",
            description: "Described",
          ),
          ControlConfig.toggle(
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
      repository: sharedPreferencesRepository,
    );
    return MaterialApp(
      home: Stack(
        children: [
          SettingsUserStory(
            namespace: "1",
            options: SettingsOptions(
              controls: settingControls,
              repository: sharedPreferencesRepository,
              saveMode: SettingsSaveMode.button,
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
