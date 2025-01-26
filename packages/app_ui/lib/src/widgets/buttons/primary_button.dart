import 'package:app_ui/app_ui.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    super.key,
    this.icon,
    this.onClick,
    this.onLongPress,
    this.enabled = true,
  });

  final String text;
  final bool enabled;
  final Widget? icon;
  final VoidCallback? onClick;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: double.infinity, height: 48),
      child: PlatformElevatedButton(
        material: (_, __) => MaterialElevatedButtonData(
          onLongPress: enabled ? onLongPress : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: enabled ? Theme.of(context).extension<AppColors>()!.primary : Colors.grey,
          ),
        ),
        cupertino: (_, __) => CupertinoElevatedButtonData(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(24),
          color: enabled ? Theme.of(context).extension<AppColors>()!.primary : Colors.grey,
        ),
        onPressed: enabled ? onClick : null,
        color: enabled ? Theme.of(context).extension<AppColors>()!.primary : Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            if (icon != null) const SizedBox(width: 8),
            Text(
              text,
              style: AppTextStyle.buttonS.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
