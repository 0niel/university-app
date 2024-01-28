import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

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
                  ? MaterialStateProperty.all<Color>(AppTheme.colorsOf(context).primary)
                  : MaterialStateProperty.all<Color>(AppTheme.colorsOf(context).background01),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            ),
            child: Text(
              text,
              style: AppTextStyle.tab.copyWith(
                color: notifier.value == itemIndex
                    ? AppTheme.colorsOf(context).active
                    : AppTheme.colorsOf(context).deactive,
              ),
            ),
          );
        },
      ),
    );
  }
}
