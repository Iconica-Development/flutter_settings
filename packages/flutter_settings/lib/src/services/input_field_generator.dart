import "package:flutter/material.dart";
import "package:flutter_input_library/flutter_input_library.dart";
import "package:flutter_settings/flutter_settings.dart";
import "package:intl/intl.dart";

class InputFieldGenerator extends StatefulWidget {
  const InputFieldGenerator({
    required this.settings,
    required this.index,
    required this.onUpdate,
    required this.settingsService,
    this.dismissKeyboardOnTap = true,
    this.controlWrapper,
    this.groupWrapper,
    super.key,
  });

  final List<Control> settings;
  final Widget Function(Widget child, Control setting)? controlWrapper;
  final Widget Function(Widget child, Control setting)? groupWrapper;
  final int index;
  final Function(void Function()) onUpdate;
  final SettingsService settingsService;

  /// Whether to dismiss the keyboard when the user taps outside of the keyboard
  /// This is only used for textfields
  final bool dismissKeyboardOnTap;

  @override
  State<InputFieldGenerator> createState() => _InputFieldGeneratorState();
}

class _InputFieldGeneratorState extends State<InputFieldGenerator> {
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _showOverlay(BuildContext context) {
    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry(BuildContext context) => OverlayEntry(
        builder: (context) => GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            _removeOverlay();
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            color: Colors.transparent,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) =>
      _inputFieldBuilder(context, widget.index);

  Widget _inputFieldBuilder(BuildContext context, int index) {
    if (widget.settings[index].content != null) {
      return _addControlWrapper(
        context,
        widget.settings[index].content!,
        widget.settings[index],
      );
    }

    return _buildInputFieldFromControlSetting(context, widget.settings[index]);
  }

  /// Wraps the child with a focus node if the dismissKeyboardOnTap is true
  /// This is only used for textfields
  Widget _buildWithFocusNodeWrapper(Widget child) => widget.dismissKeyboardOnTap
      ? Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              _showOverlay(context);
            } else {
              _removeOverlay();
            }
          },
          child: child,
        )
      : child;

  Widget _buildInputFieldFromControlSetting(
    BuildContext context,
    Control setting,
  ) {
    var theme = Theme.of(context);
    switch (setting.type) {
      case ControlType.group:
        return _addGroupWrapper(
          context,
          Column(
            children: [
              ...List.generate(
                setting.settings!.length,
                (int i) {
                  var isLastSetting = i == setting.settings!.length - 1;
                  setting.settings![i].isLastSettingInGroup = isLastSetting;
                  setting.settings![i].partOfGroup = true;

                  return InputFieldGenerator(
                    settingsService: widget.settingsService,
                    settings: setting.settings!,
                    index: i,
                    onUpdate: widget.onUpdate,
                    controlWrapper: widget.controlWrapper,
                    groupWrapper: widget.groupWrapper,
                  );
                },
              ),
            ],
          ),
          setting,
        );

      case ControlType.page:
        return _addPageControlWrapper(
          context,
          const Icon(Icons.chevron_right),
          setting,
          widget.settingsService,
        );

      case ControlType.dropDown:
        return _addInputFieldWrapper(
          context,
          DropdownButtonFormField<String>(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: theme.colorScheme.primary,
            ),
            style: theme.textTheme.bodySmall,
            isExpanded: true,
            items: ((setting.value as Map)["items"] as List<String>)
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setting.onChange?.call({setting.key: value});
              widget.onUpdate(() => (setting.value as Map)["selected"] = value);
            },
            value: (setting.value as Map)["selected"],
            hint: Text(setting.hintText ?? ""),
            decoration: setting.decoration ??
                InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  suffixIcon: setting.suffixIcon,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
            validator: setting.validator,
          ),
          setting,
        );

      case ControlType.radio:
        return _addInputFieldWrapper(
          context,
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: FlutterFormInputRadioPicker(
              items: (setting.value as Map)["items"],
              initialValue: (setting.value as Map)["selected"],
              onChanged: (value) {
                if (value != null) {
                  setting.onChange?.call({setting.key: value.value});
                  widget.onUpdate(
                    () => (setting.value as Map)["selected"] = value.value,
                  );
                }
              },
            ),
          ),
          setting,
        );

      case ControlType.textField:
        return _addInputFieldWrapper(
          context,
          _buildWithFocusNodeWrapper(
            FlutterFormInputPlainText(
              style: theme.textTheme.bodySmall,
              maxLines: setting.maxLines ?? 1,
              initialValue: setting.value != "" && setting.value != null
                  ? setting.value
                  : setting.initialValue,
              validator: setting.validator,
              keyboardType: setting.keyboardType,
              onChanged: (value) {
                setting.onChange?.call({setting.key: value});
                widget.onUpdate(() => setting.value = value);
              },
              formatInputs: setting.formatInputs,
              decoration: setting.decoration ??
                  InputDecoration(
                    hintStyle: theme.textTheme.bodySmall!.copyWith(
                      color: theme.textTheme.bodySmall!.color!.withOpacity(0.5),
                    ),
                    hintText: setting.hintText,
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
            ),
          ),
          setting,
        );

      case ControlType.toggle:
        return _addBoolControlWrapper(
          context,
          FlutterFormInputBool(
            widgetType: BoolWidgetType.switchWidget,
            onChanged: (value) {
              setting.onChange?.call({setting.key: value});
              widget.onUpdate(() => setting.value = value);
            },
            initialValue: setting.value,
          ),
          setting,
        );

      case ControlType.checkBox:
        return _addBoolControlWrapper(
          context,
          FlutterFormInputBool(
            widgetType: BoolWidgetType.checkbox,
            onChanged: (value) {
              setting.onChange?.call({setting.key: value});
              widget.onUpdate(() => setting.value = value);
            },
            initialValue: setting.value,
          ),
          setting,
        );

      case ControlType.number:
        return _addControlWrapper(
          context,
          FlutterFormInputNumberPicker(
            onChanged: (value) {
              if (value != null) {
                setting.onChange?.call({setting.key: value});
                widget.onUpdate(
                  () => (setting.value as Map)["selected"] = value,
                );
              }
            },
            minValue: 0,
            maxValue: 10,
            initialValue: (setting.value as Map)["selected"],
            axis: Axis.horizontal,
          ),
          setting,
        );

      case ControlType.date:
        var dateFormat = DateFormat("dd-MM-yyyy");

        return _addInputFieldWrapper(
          context,
          FlutterFormInputDateTime(
            style: theme.textTheme.bodySmall,
            decoration: setting.decoration ??
                InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  suffixIcon: setting.suffixIcon,
                  suffixIconColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
            inputType: FlutterFormDateTimeType.date,
            dateFormat: dateFormat,
            firstDate: (setting.value as Map)["min"],
            lastDate: (setting.value as Map)["max"],
            initialValue: dateFormat.format((setting.value as Map)["selected"]),
            initialDate: (setting.value as Map)["selected"] ?? DateTime.now(),
            onChanged: (value) {
              if (value != null) {
                var date = dateFormat.parse(value);
                setting.onChange?.call({setting.key: date});
                widget.onUpdate(
                  () => (setting.value as Map)["selected"] = date,
                );
              }
            },
            validator: setting.validator,
          ),
          setting,
        );

      case ControlType.time:
        var timeFormat = DateFormat("HH:mm");
        return _addInputFieldWrapper(
          context,
          FlutterFormInputDateTime(
            style: theme.textTheme.bodySmall,
            decoration: setting.decoration ??
                InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  suffixIcon: setting.suffixIcon,
                  suffixIconColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
            inputType: FlutterFormDateTimeType.time,
            dateFormat: timeFormat,
            initialTime: setting.value ?? TimeOfDay.now(),
            initialValue: ((setting.value) as TimeOfDay?) != null
                ? "${(setting.value as TimeOfDay).hour}:"
                    "${(setting.value as TimeOfDay).minute}"
                : null,
            onChanged: (value) {
              if (value != null) {
                var split = value.split(":");
                var time = TimeOfDay(
                  hour: int.parse(split[0]),
                  minute: int.parse(split[1]),
                );
                setting.onChange?.call({setting.key: time});
                widget.onUpdate(() => setting.value = time);
              }
            },
          ),
          setting,
        );

      case ControlType.dateRange:
        var dateFormat = DateFormat("dd-MM-yyyy");

        String? initialValue;

        if (((setting.value as Map)["selected-start"] as DateTime?) != null &&
            ((setting.value as Map)["selected-end"] as DateTime?) != null) {
          initialValue =
              // ignore: lines_longer_than_80_chars
              '${dateFormat.format((setting.value as Map)['selected-start'] as DateTime)} - ${dateFormat.format((setting.value as Map)['selected-end'] as DateTime)}';
        }

        return _addInputFieldWrapper(
          context,
          FlutterFormInputDateTime(
            style: theme.textTheme.bodySmall,
            decoration: setting.decoration ??
                InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  suffixIcon: setting.suffixIcon,
                  suffixIconColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
            inputType: FlutterFormDateTimeType.range,
            dateFormat: dateFormat,
            firstDate: (setting.value as Map)["min"],
            lastDate: (setting.value as Map)["max"],
            initialValue: initialValue,
            onChanged: (value) {
              if (value != null) {
                var split = value.split(" ");
                var start = split[0];
                var end = split[2];

                setting.onChange?.call({setting.key: value});
                widget.onUpdate(() {
                  (setting.value as Map)["selected-start"] =
                      dateFormat.parse(start);
                  (setting.value as Map)["selected-end"] =
                      dateFormat.parse(end);
                });
              }
            },
          ),
          setting,
        );

      default:
        return Container(color: Colors.red);
    }
  }

  Widget _addGroupWrapper(
    BuildContext context,
    Widget child,
    Control setting,
  ) {
    if (widget.groupWrapper != null) {
      return widget.groupWrapper!.call(child, setting);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (setting.title != null)
          Padding(
            padding: const EdgeInsets.only(
              top: 24,
              left: 24,
              bottom: 8,
            ),
            child: Text(
              setting.title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.color
                        ?.withOpacity(0.5),
                  ),
            ),
          ),
        child,
      ],
    );
  }

  Widget _addPageControlWrapper(
    BuildContext context,
    Widget child,
    Control setting,
    SettingsService settingsService,
  ) {
    if (widget.controlWrapper != null) {
      return widget.controlWrapper!.call(child, setting);
    }
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () async {
        if (setting.onTap != null) {
          setting.onTap!();
          return;
        }
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  setting.title != null
                      ? setting.capitalizeFirstLetter
                          ? setting.title!
                          : setting.title!.toLowerCase()
                      : "Page",
                ),
              ),
              body: SingleChildScrollView(
                child: DeviceSettingsPage(
                  settingsService: widget.settingsService,
                  settings: setting.settings ?? [],
                  controlWrapper: widget.controlWrapper,
                  groupWrapper: widget.groupWrapper,
                ),
              ),
            ),
          ),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: setting.isLastSettingInGroup
                ? BorderSide(
                    color: theme.dividerColor,
                    width: 1,
                  )
                : BorderSide.none,
            top: BorderSide(
              color: theme.dividerColor,
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              if (setting.prefixIcon != null) ...[
                SizedBox(
                  width: 64,
                  child: setting.prefixIcon,
                ),
              ] else ...[
                const SizedBox(width: 20),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (setting.title != null)
                      Text(
                        setting.title!,
                        style: theme.textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (setting.description != null)
                      Text(
                        setting.description!,
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: child,
              ),
            ],
          ),
        ),
  
      ),
    );
  }

  Widget _addInputFieldWrapper(
    BuildContext context,
    Widget child,
    Control setting,
  ) {
    var theme = Theme.of(context);
    if (widget.controlWrapper != null) {
      return widget.controlWrapper!.call(child, setting);
    }

    return Column(
      children: [
        if (!setting.partOfGroup)
          const SizedBox(
            height: 24,
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: setting.isLastSettingInGroup
                  ? BorderSide(
                      color: theme.dividerColor,
                      width: 1,
                    )
                  : !setting.partOfGroup
                      ? BorderSide(
                          color: theme.dividerColor,
                          width: 1,
                        )
                      : BorderSide.none,
              top: BorderSide(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            color: const Color(0xFFEEEEEE),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: setting.type == ControlType.radio ? 16 : 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (setting.title != null) ...[
                  Text(
                    setting.title!,
                    style: theme.textTheme.titleMedium,
                  ),
                ],
                if (setting.description != null) ...[
                  Text(
                    setting.description!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
                if (setting.title != null || setting.description != null)
                  const SizedBox(
                    height: 4,
                  ),
                child,
              ],
            ),
          ),
        ),
        if (setting.isLastSettingInGroup)
          const SizedBox(
            height: 24,
          ),
      ],
    );
  }

  Widget _addControlWrapper(
    BuildContext context,
    Widget child,
    Control setting,
  ) {
    var theme = Theme.of(context);
    if (widget.controlWrapper != null) {
      return widget.controlWrapper!.call(child, setting);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          child,
          if (setting.description != null) ...[
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                setting.description!,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _addBoolControlWrapper(
    BuildContext context,
    Widget child,
    Control setting,
  ) {
    var theme = Theme.of(context);
    if (widget.controlWrapper != null) {
      return widget.controlWrapper!.call(child, setting);
    }
    return Column(
      children: [
        if (!setting.partOfGroup)
          const SizedBox(
            height: 24,
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: setting.isLastSettingInGroup
                  ? BorderSide(
                      color: theme.dividerColor,
                      width: 1,
                    )
                  : !setting.partOfGroup
                      ? BorderSide(
                          color: theme.dividerColor,
                          width: 1,
                        )
                      : BorderSide.none,
              top: BorderSide(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            color: const Color(0xFFEEEEEE),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    if (setting.prefixIcon != null) ...[
                      SizedBox(
                        width: 64,
                        child: setting.prefixIcon,
                      ),
                    ] else ...[
                      const SizedBox(width: 20),
                    ],
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          setting.title ?? "",
                          style: theme.textTheme.titleMedium,
                        ),
                        if (setting.description != null) ...[
                          Text(
                            setting.description!,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
