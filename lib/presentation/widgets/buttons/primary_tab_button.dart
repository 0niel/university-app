import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class PrimaryTabButton extends StatelessWidget {
  final String text;
  final int itemIndex;
  final ValueNotifier<int> notifier;
  final VoidCallback onClick;

  const PrimaryTabButton({
    Key? key,
    required this.onClick,
    required this.notifier,
    required this.text,
    required this.itemIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ValueListenableBuilder(
        valueListenable: notifier,
        builder: (BuildContext context, index, child) {
          return ElevatedButton(
            onPressed: () {
              notifier.value = itemIndex;
              onClick();
            },
            style: ButtonStyle(
              backgroundColor: notifier.value == itemIndex
                  ? MaterialStateProperty.all<Color>(DarkThemeColors.primary)
                  : MaterialStateProperty.all<Color>(
                      DarkThemeColors.background01),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            ),
            child: Text(text,
                style: DarkTextTheme.tab.copyWith(
                  color: notifier.value == itemIndex
                      ? DarkThemeColors.active
                      : DarkThemeColors.deactive,
                )),
          );
        },
      ),
    );
  }
}
