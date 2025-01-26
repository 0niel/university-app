import 'package:app_ui/app_ui.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';

class PrimaryTabButton extends StatelessWidget {
  const PrimaryTabButton({
    required this.onClick,
    required this.notifier,
    required this.text,
    required this.itemIndex,
    super.key,
  });
  final String text;
  final int itemIndex;
  final ValueNotifier<int> notifier;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ValueListenableBuilder(
        valueListenable: notifier,
        builder: (BuildContext context, index, child) {
          return PlatformElevatedButton(
            onPressed: () {
              notifier.value = itemIndex;
              onClick();
            },
            material: (_, __) => MaterialElevatedButtonData(
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: notifier.value == itemIndex
                    ? Theme.of(context).extension<AppColors>()!.primary
                    : Theme.of(context).extension<AppColors>()!.background01,
              ),
            ),
            color: notifier.value == itemIndex
                ? Theme.of(context).extension<AppColors>()!.primary
                : Theme.of(context).extension<AppColors>()!.background01,
            cupertino: (_, __) => CupertinoElevatedButtonData(
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              text,
              style: AppTextStyle.tab.copyWith(
                color: notifier.value == itemIndex
                    ? Theme.of(context).extension<AppColors>()!.active
                    : Theme.of(context).extension<AppColors>()!.deactive.withAlpha(200),
              ),
            ),
          );
        },
      ),
    );
  }
}
