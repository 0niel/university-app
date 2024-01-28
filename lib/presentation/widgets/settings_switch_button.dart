import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class SettingsSwitchButton extends StatefulWidget {
  const SettingsSwitchButton({
    Key? key,
    this.svgPicture,
    this.icon,
    required this.text,
    required this.onChanged,
    required this.initialValue,
  })  : assert(svgPicture != null || icon != null, 'Icon can\'t be null'),
        super(key: key);

  final SvgPicture? svgPicture;
  final Widget? icon;
  final String text;
  final Function(bool) onChanged;
  final bool initialValue;

  @override
  State<SettingsSwitchButton> createState() => _SettingsSwitchButtonState();
}

class _SettingsSwitchButtonState extends State<SettingsSwitchButton> {
  late ValueNotifier<bool> _switchValueNotifier;

  @override
  void initState() {
    super.initState();
    _switchValueNotifier = ValueNotifier(widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              widget.svgPicture ?? widget.icon!,
              const SizedBox(width: 20),
              Text(widget.text, style: AppTextStyle.buttonL.copyWith(color: AppTheme.colorsOf(context).active)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ValueListenableBuilder(
              valueListenable: _switchValueNotifier,
              builder: (context, hasError, child) => CupertinoSwitch(
                activeColor: AppTheme.colorsOf(context).primary,
                value: _switchValueNotifier.value,
                onChanged: (value) {
                  _switchValueNotifier.value = value;
                  widget.onChanged(value);
                },
              ),
            ),
          ),
        ],
      ),
      onPressed: () {
        _switchValueNotifier.value = !_switchValueNotifier.value;
      },
    );
  }
}
