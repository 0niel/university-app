import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    required this.icon,
    required this.onClick,
    super.key,
    this.text,
    this.assetPath,
  });

  factory SocialIconButton.asset({
    required String assetPath,
    required VoidCallback onClick,
    String? text,
  }) =>
      SocialIconButton(
        icon: const Icon(Icons.add),
        onClick: onClick,
        text: text,
        assetPath: assetPath,
      );

  final Icon icon;
  final VoidCallback onClick;
  final String? text;
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: Theme.of(context).extension<AppColors>()!.deactive,
            ),
          ),
        ),
      ),
      onPressed: onClick,
      child: text != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text!,
                  style: AppTextStyle.buttonS.copyWith(
                    color: Theme.of(context).extension<AppColors>()!.active,
                  ),
                ),
                const SizedBox(width: 8),
                if (assetPath != null) Image.asset(assetPath!, height: 16, width: 16) else icon,
              ],
            )
          : assetPath != null
              ? Image.asset(assetPath!, height: 16, width: 16)
              : icon,
    );
  }
}
