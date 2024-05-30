import 'package:flutter/material.dart';
import 'package:flutter_settings/flutter_settings.dart';
import 'package:intl/intl.dart';

class InputFieldGenerator extends StatefulWidget {
  const InputFieldGenerator({
    required this.settings,
    required this.index,
    required this.onUpdate,
    this.controlWrapper,
    this.groupWrapper,
    super.key,
  });

  final List<Control> settings;
  final Widget Function(Widget child, Control setting, {bool partOfGroup})?
      controlWrapper;
  final Widget Function(Widget child, Control setting)? groupWrapper;
  final int index;
  final Function(void Function()) onUpdate;

  @override
  State<InputFieldGenerator> createState() => _InputFieldGeneratorState();
}

class _InputFieldGeneratorState extends State<InputFieldGenerator> {
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

  Widget _buildInputFieldFromControlSetting(
    BuildContext context,
    Control setting,
  ) {
    switch (setting.type) {
      case ControlType.group:
        return _addGroupWrapper(
          context,
          Column(
            children: [
              ...List.generate(
                setting.settings!.length,
                (int i) => _buildInputFieldFromControlSetting(
                  context,
                  setting.settings![i],
                ),
              ),
            ],
          ),
          setting,
        );

      case ControlType.page:
        return _addPageControlWrapper(
          context,
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: Text(
                        setting.title ?? 'Page',
                      ),
                    ),
                    body: DeviceSettingsPage(
                      settings: setting.settings ?? [],
                      controlWrapper: widget.controlWrapper,
                      groupWrapper: widget.groupWrapper,
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.chevron_right),
          ),
          setting,
        );

      case ControlType.dropDown:
        return _addControlWrapper(
          context,
          DropdownButtonFormField<String>(
            isExpanded: true,
            items: ((setting.value as Map)['items'] as List<String>)
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setting.onChange?.call({setting.key: value});
              widget.onUpdate(() => (setting.value as Map)['selected'] = value);
            },
            value: (setting.value as Map)['selected'],
            hint: Text(setting.title ?? ''),
            decoration: setting.decoration ??
                InputDecoration(
                  suffixIcon: setting.suffixIcon,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
            validator: setting.validator,
          ),
          setting,
        );

      case ControlType.radio:
        return _addControlWrapper(
          context,
          FlutterFormInputRadioPicker(
            items: (setting.value as Map)['items'],
            initialValue: (setting.value as Map)['selected'],
            onChanged: (value) {
              if (value != null) {
                setting.onChange?.call(value.value);
                widget.onUpdate(
                  () => (setting.value as Map)['selected'] = value.value,
                );
              }
            },
          ),
          setting,
        );

      case ControlType.textField:
        return _addControlWrapper(
          context,
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            child: FlutterFormInputPlainText(
              maxLines: setting.maxLines ?? 1,
              initialValue: setting.value ?? '',
              validator: setting.validator,
              keyboardType: setting.keyboardType,
              onChanged: (value) {
                setting.onChange?.call({setting.key: value});
                widget.onUpdate(() => setting.value = value);
              },
              formatInputs: setting.formatInputs,
              decoration: setting.decoration ??
                  InputDecoration(
                    suffixIcon: setting.suffixIcon,
                    labelText: (setting.title != null)
                        ? setting.isRequired
                            ? '${setting.title}*'
                            : setting.title ?? ''
                        : '',
                    suffixIconColor: Colors.black,
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.labelMedium?.color,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
              style: TextStyle(
                color: Theme.of(context).textTheme.labelMedium?.color,
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
                  () => (setting.value as Map)['selected'] = value,
                );
              }
            },
            minValue: 0,
            maxValue: 10,
            initialValue: (setting.value as Map)['selected'],
            axis: Axis.horizontal,
          ),
          setting,
        );

      case ControlType.date:
        var dateFormat = DateFormat('dd-MM-yyyy');

        return _addControlWrapper(
          context,
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            child: FlutterFormInputDateTime(
              style: TextStyle(
                color: Theme.of(context).textTheme.labelMedium?.color,
              ),
              decoration: setting.decoration ??
                  InputDecoration(
                    suffixIcon: setting.suffixIcon,
                    suffixIconColor: Colors.black,
                    labelText: setting.title ?? '',
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.labelMedium?.color,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
              inputType: FlutterFormDateTimeType.date,
              dateFormat: dateFormat,
              firstDate: (setting.value as Map)['min'],
              lastDate: (setting.value as Map)['max'],
              initialValue:
                  dateFormat.format((setting.value as Map)['selected']),
              initialDate: (setting.value as Map)['selected'] ?? DateTime.now(),
              onChanged: (value) {
                if (value != null) {
                  var date = dateFormat.parse(value);
                  setting.onChange?.call({setting.key: date});
                  widget.onUpdate(
                    () => (setting.value as Map)['selected'] = date,
                  );
                }
              },
              validator: setting.validator,
            ),
          ),
          setting,
        );

      case ControlType.time:
        var timeFormat = DateFormat('HH:mm');
        return _addControlWrapper(
          context,
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            child: FlutterFormInputDateTime(
              decoration: setting.decoration ??
                  InputDecoration(
                    suffixIcon: setting.suffixIcon,
                    suffixIconColor: Colors.black,
                    labelText: setting.title ?? '',
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.labelMedium?.color,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
              inputType: FlutterFormDateTimeType.time,
              dateFormat: timeFormat,
              initialTime: setting.value ?? TimeOfDay.now(),
              initialValue: ((setting.value) as TimeOfDay?) != null
                  ? '${(setting.value as TimeOfDay).hour}:'
                      '${(setting.value as TimeOfDay).minute}'
                  : null,
              onChanged: (value) {
                if (value != null) {
                  var split = value.split(':');
                  var time = TimeOfDay(
                    hour: int.parse(split[0]),
                    minute: int.parse(split[1]),
                  );
                  setting.onChange?.call({setting.key: time});
                  widget.onUpdate(() => setting.value = time);
                }
              },
            ),
          ),
          setting,
        );

      case ControlType.dateRange:
        var dateFormat = DateFormat('dd-MM-yyyy');

        String? initialValue;

        if (((setting.value as Map)['selected-start'] as DateTime?) != null &&
            ((setting.value as Map)['selected-end'] as DateTime?) != null) {
          initialValue =
              // ignore: lines_longer_than_80_chars
              '${dateFormat.format((setting.value as Map)['selected-start'] as DateTime)} - ${dateFormat.format((setting.value as Map)['selected-end'] as DateTime)}';
        }

        return _addControlWrapper(
          context,
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            child: FlutterFormInputDateTime(
              decoration: setting.decoration ??
                  InputDecoration(
                    suffixIcon: setting.suffixIcon,
                    suffixIconColor: Colors.black,
                    labelText: setting.title ?? '',
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.labelMedium?.color,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
              inputType: FlutterFormDateTimeType.range,
              dateFormat: dateFormat,
              firstDate: (setting.value as Map)['min'],
              lastDate: (setting.value as Map)['max'],
              initialValue: initialValue,
              onChanged: (value) {
                if (value != null) {
                  var split = value.split(' ');
                  var start = split[0];
                  var end = split[2];

                  setting.onChange?.call({setting.key: value});
                  widget.onUpdate(() {
                    (setting.value as Map)['selected-start'] =
                        dateFormat.parse(start);
                    (setting.value as Map)['selected-end'] =
                        dateFormat.parse(end);
                  });
                }
              },
            ),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: setting.boxDecoration ??
            BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            child,
          ],
        ),
      ),
    );
  }

  Widget _addPageControlWrapper(
    BuildContext context,
    Widget child,
    Control setting,
  ) {
    if (widget.controlWrapper != null) {
      return widget.controlWrapper!.call(child, setting);
    }
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 12,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (setting.title != null)
                        Text(
                          setting.title!,
                          style: theme.textTheme.titleMedium,
                        ),
                      if (setting.description != null)
                        Text(
                          setting.description!,
                          style: theme.textTheme.titleSmall,
                        ),
                    ],
                  ),
                  child,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addControlWrapper(
    BuildContext context,
    Widget child,
    Control setting,
  ) {
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
            Text(
              setting.description!,
              style: Theme.of(context).textTheme.titleSmall,
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
    if (widget.controlWrapper != null) {
      return widget.controlWrapper!.call(child, setting);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              child,
              const SizedBox(
                width: 4,
              ),
              Text(setting.title ?? ''),
            ],
          ),
          if (setting.description != null) ...[
            const SizedBox(
              height: 8,
            ),
            Text(
              setting.description!,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ],
      ),
    );
  }
}
