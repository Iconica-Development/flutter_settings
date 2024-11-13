import "package:flutter/material.dart";
import "package:flutter_settings/src/config/controls/base.dart";
import "package:flutter_settings/src/config/defaults.dart";
import "package:flutter_settings/src/service/settings_control_controller.dart";
import "package:settings_repository/settings_repository.dart";

///
class TextControlConfig
    extends DescriptiveTitleControlConfig<String, TextControlConfig> {
  ///
  TextControlConfig({
    required super.title,
    required String key,
    this.decoration,
    super.description,
    super.wrapperBuilder = defaultDescriptionTitleControlWrapper,
  }) : super(
          initialValue: SettingsControl<String>(key: key),
        );

  ///
  final InputDecoration? decoration;

  @override
  Widget buildSetting(
    BuildContext context,
    SettingsControl<String> control,
    SettingsControlController controller,
  ) =>
      SizedBox(
        width: 150,
        child: _TextControl(
          value: control.value ?? "",
          onChanged: (value) async {
            await controller.updateControl(
              control.update(value),
            );
          },
          decoration: decoration,
        ),
      );
}

class _TextControl extends StatefulWidget {
  const _TextControl({
    required this.value,
    required this.onChanged,
    required this.decoration,
  });

  ///
  final String value;
  final void Function(String value) onChanged;
  final InputDecoration? decoration;

  @override
  State<_TextControl> createState() => _TextControlState();
}

class _TextControlState extends State<_TextControl> {
  late final controller = TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(covariant _TextControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != controller.text) {
      controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        decoration: widget.decoration,
        onChanged: widget.onChanged,
      );
}
