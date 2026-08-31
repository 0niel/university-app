import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaCommunityFab extends StatelessWidget {
  const NinjaCommunityFab({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon = AppLineIcon.plus,
  });

  final String label;
  final AppLineIcon icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final maxWidth =
        (MediaQuery.widthOf(context) - NinjaMetrics.screenPadding * 2).clamp(
          0.0,
          double.infinity,
        );
    final foreground = colors.onBrand;
    return SafeArea(
      child: Semantics(
        button: true,
        enabled: onPressed != null,
        label: label,
        child: AppPressable(
          pressedScale: 0.96,
          onTap: onPressed,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: onPressed == null ? colors.surface : colors.brand,
              borderRadius: BorderRadius.circular(NinjaRadius.pill),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 52, maxWidth: maxWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppLineIconWidget(
                      icon,
                      size: 20,
                      color: onPressed == null ? colors.disabled : foreground,
                    ),
                    const SizedBox(width: 9),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: NinjaText.button.copyWith(
                          color: onPressed == null
                              ? colors.disabled
                              : foreground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
