import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class SettingsSwitchButton extends StatefulWidget {
  const SettingsSwitchButton({
    Key? key,
    required this.svgPicture,
    required this.text,
    required this.onChanged,
    required this.initialValue,
  }) : super(key: key);

  final SvgPicture svgPicture;
  final String text;
  final Function(bool) onChanged;
  final bool initialValue;

  @override
  _SettingsSwitchButtonState createState() => _SettingsSwitchButtonState();
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
    return InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                widget.svgPicture,
                const SizedBox(width: 20),
                Text(widget.text, style: DarkTextTheme.buttonL),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ValueListenableBuilder(
                valueListenable: _switchValueNotifier,
                builder: (context, hasError, child) => CupertinoSwitch(
                  activeColor: DarkThemeColors.primary,
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
        onTap: () {
          _switchValueNotifier.value = !_switchValueNotifier.value;
        });
  }
}
