import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class FeedSectionHeader extends StatelessWidget {
  const FeedSectionHeader({
    required this.title,
    super.key,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final action = actionLabel;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        28,
        NinjaMetrics.screenPadding,
        AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: NinjaText.title.copyWith(color: colors.ink),
            ),
          ),
          if (action != null && action.isNotEmpty) ...[
            const SizedBox(width: AppSpacing.gap),
            AppPressable(
              onTap: onAction,
              semanticsLabel: action,
              semanticsButton: true,
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: NinjaMetrics.minTouchTarget,
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: colors.surfaceAlt,
                  borderRadius: BorderRadius.circular(NinjaRadius.pill),
                ),
                child: Text(
                  action,
                  style: NinjaText.buttonSmall.copyWith(color: colors.ink),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
