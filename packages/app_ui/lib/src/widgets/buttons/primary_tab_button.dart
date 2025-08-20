import 'package:app_ui/app_ui.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';

class PrimaryTabButton extends StatelessWidget {
  const PrimaryTabButton({
    required this.onClick,
    required this.notifier,
    required this.text,
    required this.itemIndex,
    this.icon,
    super.key,
  });
  final String text;
  final int itemIndex;
  final ValueNotifier<int> notifier;
  final VoidCallback onClick;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
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
                minimumSize: const Size(60, 32),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
            ),
            color: notifier.value == itemIndex
                ? Theme.of(context).extension<AppColors>()!.primary
                : Theme.of(context).extension<AppColors>()!.background01,
            cupertino: (_, __) => CupertinoElevatedButtonData(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: AppTextStyle.tab.copyWith(
                    color: notifier.value == itemIndex
                        ? Theme.of(context).extension<AppColors>()!.active
                        : Theme.of(context)
                            .extension<AppColors>()!
                            .deactive
                            .withAlpha(200),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
