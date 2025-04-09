import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_settings_repository/firebase_settings_repository.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:settings_repository/settings_repository.dart";

late final FirebaseSettingsRepository firestoreRepository;

var _controls = [
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
    title: "Text",
    children: [
      ControlConfig.text(
        key: "text_1",
        title: "My Text",
        description: "Described",
        maxLines: 3,
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
      ),
    ],
  ),
];

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  var app = await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );

  firestoreRepository = FirebaseSettingsRepository(
    firestore: FirebaseFirestore.instanceFor(app: app),
  );

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
  ) =>
      Slider(
        max: 10,
        value: control.value?.toDouble() ?? 0.0,
        onChanged: (value) async =>
            controller.updateControl(control.update(value.toInt())),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var settingsService = SettingsService(
      namespace: "1",
      repository: firestoreRepository,
    );
    return MaterialApp(
      home: Stack(
        children: [
          SettingsUserStory(
            namespace: "1",
            options: SettingsOptions(
              controls: _controls,
              repository: firestoreRepository,
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
                onPressed: () async => settingsService.setValue("test_1", true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
