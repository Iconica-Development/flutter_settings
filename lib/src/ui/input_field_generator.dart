import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_input_library/flutter_input_library.dart';
import 'package:flutter_settings/src/ui/control.dart';
import 'package:intl/intl.dart';

class InputFieldGenerator extends StatefulWidget {
  const InputFieldGenerator({
    required this.settings,
    required this.index,
    required this.onUpdate,
    super.key,
  });

  final List<Control> settings;
  final int index;
  final Function(void Function()) onUpdate;

  @override
  State<InputFieldGenerator> createState() => _InputFieldGeneratorState();
}

//TODO(Jacques): Reinstate translations
class _InputFieldGeneratorState extends State<InputFieldGenerator> {
  @override
  Widget build(BuildContext context) =>
      _inputFieldBuilder(context, widget.index);

  Widget _inputFieldBuilder(BuildContext context, int index) {
    if (!_checkCondition(widget.settings[index])!) {
      return const SizedBox.shrink();
    }

    if (widget.settings[index].content != null) {
      return _addConstraints(widget.settings[index].content);
    }

    return _buildInputFieldFromControlSetting(context, widget.settings[index]);
  }

  Widget _buildInputFieldFromControlSetting(
    BuildContext context,
    Control setting, {
    bool allowGroups = true,
  }) {
    switch (setting.type) {
      case ControlType.group:
        if (allowGroups) {
          return _addConstraints(
            Column(
              children: [
                if (setting.title != null && setting.title != '') ...[
                  Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 10),
                    child: Text(
                      setting.title!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Card(
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.lerp(
                        BorderRadius.circular(5.0),
                        BorderRadius.circular(5.0),
                        5.0,
                      )!,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textTheme: Theme.of(context).textTheme.copyWith(
                                bodyLarge:
                                    Theme.of(context).textTheme.bodyMedium,
                                titleLarge: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.fontSize,
                                    ),
                              ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                            setting.settings!.length,
                            (int i) => _buildInputFieldFromControlSetting(
                              context,
                              setting.settings![i],
                              allowGroups: false,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          continue fallback;
        }

      case ControlType.page:
        return _addConstraints(
          FlutterFormInputPlainText(
            label: Text(setting.title!),
            decoration: InputDecoration(
              icon: setting.value['icon'],
            ),
          ),
        );

      case ControlType.dropDown:
        return _addConstraints(
          DropdownButton(
            items: (setting.value['items'] as List<String>)
                .map((e) => DropdownMenuItem(child: Text(e)))
                .toList(),
            onChanged: (
              value,
            ) {
              setting.onChange?.call(value);
              widget.onUpdate(() => setting.value['selected'] = value);
            },
            value: setting.value['selected'],
            hint: Text(setting.title ?? ''),
            //TODO(Jacques): Add description: setting.description
          ),
        );

      case ControlType.radio:
        return _addConstraints(
          //TODO(Jacques): Implement radio
          SizedBox.shrink(),
          // context.appShell().config.appTheme.inputs.radio<int>(
          //       value: setting.value['selected'],
          //       entries: (setting.value['options'] as List<String>).asMap(),
          //       title: setting.title,
          //       description: setting.description,
          //       onChange: (value, valid) {
          //         if (valid) {
          //           setting.onChange?.call(value);
          //           widget.onUpdate(() => setting.value['selected'] = value);
          //         }
          //       },
          //     ),
        );

      case ControlType.textField:
        return _addConstraints(
          FlutterFormInputPlainText(
            initialValue: setting.value ?? '',
            label: Text(
              (setting.title != null)
                  ? setting.isRequired
                      ? '${setting.title}*'
                      : setting.title ?? ''
                  : '',
            ),
            //TODO: Add description
            //TODO: Add validator
            keyboardType: setting.keyboardType,
            onChanged: (value) {
              setting.onChange?.call(value);
              widget.onUpdate(() => setting.value = value);
            },
          ),
        );

      case ControlType.toggle:
        return _addConstraints(
          FlutterFormInputBool(
            widgetType: BoolWidgetType.switchWidget,
            onChanged: (value) {
              setting.onChange?.call(value);
              widget.onUpdate(() => setting.value = value);
            },
          ),
        );

      case ControlType.checkBox:
        return _addConstraints(
          FlutterFormInputBool(
            widgetType: BoolWidgetType.checkbox,
            onChanged: (value) {
              setting.onChange?.call(value);
              widget.onUpdate(() => setting.value = value);
            },
          ),
        );

      case ControlType.range:
        return _addConstraints(
          SizedBox.shrink(),
          //TODO: Implement range input
          // context.appShell().config.appTheme.inputs.range(
          //       value: setting.value['selected'],
          //       min: setting.value['min'],
          //       max: setting.value['max'],
          //       step: setting.value['step'],
          //       title: setting.title,
          //       description: setting.description,
          //       onChange: (value, valid) {
          //         if (valid) {
          //           setting.onChange?.call(value);
          //           widget.onUpdate(() => setting.value['selected'] = value);
          //         }
          //       },
          //     ),
        );

      case ControlType.number:
        return _addConstraints(
          FlutterFormInputNumberPicker(
            onChanged: (value) {
              setting.onChange?.call(value);
              widget.onUpdate(() => setting.value['selected'] = value);
            },
            minValue: setting.value['min'],
            maxValue: setting.value['max'],
          ),
        );

      case ControlType.date:
        return _addConstraints(
          FlutterFormInputDateTime(
            inputType: FlutterFormDateTimeType.date,
            dateFormat: DateFormat('dd-MM-yyyy'),
            firstDate: setting.value['min'],
            lastDate: setting.value['max'],
            initialValue: setting.value['selected'],
          ),
        );

      case ControlType.time:
        return _addConstraints(
          FlutterFormInputDateTime(
            inputType: FlutterFormDateTimeType.time,
            dateFormat: DateFormat('HH:mm'),
            firstDate: setting.value['min'],
            lastDate: setting.value['max'],
            initialValue: setting.value['selected'],
          ),
        );

      case ControlType.dateRange:
        return _addConstraints(
          FlutterFormInputDateTime(
            inputType: FlutterFormDateTimeType.range,
            dateFormat: DateFormat('dd-MM-yyyy'),
            firstDate: setting.value['min'],
            lastDate: setting.value['max'],
            initialValue: setting.value['selected'],
          ),
        );

      fallback:
      default:
        return Container(color: Colors.red);
    }
  }

  Widget _addConstraints(Widget? child) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        constraints: BoxConstraints(
          maxWidth: kIsWeb ? 600 : MediaQuery.of(context).size.width - 20,
        ),
        child: child,
      );

  Control? _findSetting(List<Control>? settings, Control target) {
    if (target.condition == null) {
      return null;
    }

    for (var s in settings!) {
      if (s.key == target.condition) {
        return s;
      }

      if (s.settings != null) {
        var result = _findSetting(s.settings, target);

        if (result != null) {
          return result;
        }
      }
    }

    return null;
  }

  bool? _checkCondition(Control target) {
    if (target.condition is String) {
      var src = _findSetting(widget.settings, target);
      if (src != null && src.value != null) {
        return src.value;
      }
    } else if (target.condition is bool) {
      return target.condition;
    }

    return true;
  }
}
