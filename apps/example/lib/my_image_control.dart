import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:image_picker/image_picker.dart";
import "package:settings_repository/settings_repository.dart";

class MyImageControl
    extends DescriptiveTitleControlConfig<String, MyImageControl> {
  MyImageControl({
    required String key,
    required super.title,
    super.description,
    super.wrapperBuilder = defaultDescriptionTitleControlWrapper,
    super.dependencies = const [],
  }) : super(
          initialValue: SettingsControl(
            key: key,
            dependencies: dependencies.getControlDependencies(),
          ),
        );

  final ImagePicker _picker = ImagePicker();

  @override
  Widget buildSetting(
    BuildContext context,
    SettingsControl<String> control,
    SettingsControlController controller,
  ) =>
      HookBuilder(
        builder: (context) {
          var imageProvider = useMemoized(
            () {
              if (control.value?.isNotEmpty ?? false) {
                var data = base64Decode(control.value!);
                return MemoryImage(data);
              }
              return null;
            },
            [control.value],
          );
          return SizedBox(
            width: 216,
            child: Row(
              children: [
                if (imageProvider != null) ...[
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image(image: imageProvider),
                  ),
                ],
                const SizedBox(width: 16),
                IconButton(
                  iconSize: 50,
                  onPressed: () async {
                    var pickedImage =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      await controller.updateControl(
                        control.update(
                          base64Encode(await pickedImage.readAsBytes()),
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.image,
                  ),
                ),
              ],
            ),
          );
        },
      );
}
