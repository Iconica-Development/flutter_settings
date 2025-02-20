import 'package:device_settings_repository/device_settings_repository.dart';
import 'package:example/my_image_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_settings/flutter_settings.dart';
import 'package:intl/intl.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final sharedPreferencesRepository = DeviceSettingsRepository();

List<SettingsControlConfig> getSettingControls() => <SettingsControlConfig>[
      ControlConfig.group(
        title: "Custom Sliders",
        children: [
          MyCustomSetting(
            title: "Title",
            description: "My description",
            initialValue: const SettingsControl(key: "int_slider_1"),
          ),
          MyCustomSetting(
            title: "Title",
            description: "My description",
            initialValue: const SettingsControl(key: "int_slider_2"),
          ),
        ],
      ),
      ControlConfig.group(
        title: "Time Input",
        children: [
          ControlConfig.time(
            key: "basic_time_picker",
            title: "My Time Picker",
            description: "Described.",
            hintText: "Select Time",
          ),
          ControlConfig.time(
            key: "custom_time_picker",
            title: "Time Picker - 12H Format",
            description: "Described.",
            hintText: "HH:mm AM/PM",
            timeFormat: DateFormat("hh:mm a"),
          ),
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
          ControlConfig.toggle(
            key: "test_2",
            title: "My Toggle",
            description: "Described",
          ),
        ],
      ),
      ControlConfig.group(
        title: 'Checkboxes',
        children: [
          ControlConfig.checkbox(
            key: "checkbox_1",
            title: "My Checkbox",
            description: "Described",
          ),
          ControlConfig.checkbox(
            key: "checkbox_2",
            title: "My Checkbox",
            description: "Described",
          ),
        ],
      ),
      ControlConfig.group(
        title: "Date Input Examples",
        children: [
          ControlConfig.date(
            key: "basic_date_picker",
            title: "Pick a Date",
            description: "Select a date using a calendar picker.",
            hintText: "Select Date",
            maxwidth: 160,
          ),
          ControlConfig.date(
            key: "custom_date_picker",
            title: "Pick a Date with Custom Range",
            description:
                "Choose a date within a limited range and custom format.",
            hintText: "DD/MM/YYYY",
            firstDate: DateTime(2000),
            lastDate: DateTime(2001),
            suffixIcon: const Icon(Icons.calendar_today),
            maxwidth: 200,
          ),
          ControlConfig.date(
            key: "styled_date_picker",
            title: "Styled Date Picker",
            description: "A date picker with custom input decoration.",
            hintText: "DD/MM/YYYY",
            maxwidth: 240,
            inputDecoration: InputDecoration(
              fillColor: Colors.deepPurple[200],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      ControlConfig.group(
        title: 'Text',
        children: [
          ControlConfig.text(
            key: "text_1",
            title: "My Text",
            description: "Described",
            maxLines: 3,
            dependencies: [
              ControlDependency(
                control: const SettingsControl<String>(key: "styled_date_picker"),
                builder: (context, child, control) {
                  var value = control.value;
                  var format = DateFormat();
                  if (value != null &&
                      format.parse(value).isBefore(DateTime.now())) {
                    return const Text(
                      "Whoopsie, this only is available in the future",
                    );
                  }
                  return child;
                },
              ),
            ],
          ),
          ControlConfig.text(
            key: "text_2",
            title: "Numeric Input",
            description: "Described",
            hintText: "Enter numbers only",
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
            options: ["Light", "Dark", "Adaptive Control"],
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
        title: "Dropdowns",
        children: [
          ControlConfig.dropdown(
            key: "dropdown_test",
            title: "Dropdown Example",
            description: "Described",
            hintText: "Select an item",
            options: ["Item 1", "Item 2", "Item 3", "Item 4"],
            inputDecoration: const InputDecoration(
              icon: Icon(Icons.abc),
              fillColor: Colors.red,
              filled: true,
            ),
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
            dependencies: [
              ControlDependency(
                control: const SettingsControl<String>(key: "radio_1"),
                builder: (context, child, control) {
                  var value = control.value;
                  if (value == "Dark") {
                    return Theme(data: ThemeData.dark(), child: child);
                  }
                  return null;
                },
              ),
            ],
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
          ),
          MyImageControl(key: "my_image", title: "Mikey"),
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
    super.dependencies = const [],
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
      locale: const Locale("nl", "NL"),
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale("nl", "NL")],
      home: Stack(
        children: [
          SettingsUserStory(
            namespace: "1",
            options: SettingsOptions(
              controls: getSettingControls(),
              repository: sharedPreferencesRepository,
              saveMode: SettingsSaveMode.onExitPage,
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
