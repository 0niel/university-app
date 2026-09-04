import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class PromoHeroCard extends StatelessWidget {
  const PromoHeroCard({
    required this.accent,
    required this.emoji,
    required this.title,
    super.key,
    this.badge,
    this.subtitle,
    this.tags = const [],
  });

  final Color accent;
  final String emoji;
  final String title;
  final String? badge;
  final String? subtitle;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final white = colors.white;
    final badge = this.badge;
    final subtitle = this.subtitle;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(AppRadius.hero),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: badge == null
                    ? const SizedBox.shrink()
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.gap,
                            vertical: AppSpacing.fine,
                          ),
                          decoration: BoxDecoration(
                            color: white.withValues(alpha: .18),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            badge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.subtextBold.copyWith(color: white),
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                emoji,
                style: AppText.sans(44, FontWeight.w400, height: 1),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppBalancedText(
            title,
            style: AppText.serif(
              30,
              height: 1.08,
              letterSpacingEm: -.02,
            ).copyWith(color: white),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.gap),
            Text(
              subtitle,
              style: AppText.sans(
                15,
                FontWeight.w500,
                height: 1.4,
              ).copyWith(color: white.withValues(alpha: .84)),
            ),
          ],
          if (tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.xsm,
              runSpacing: AppSpacing.xsm,
              children: [
                for (final tag in tags)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.gap,
                      vertical: AppSpacing.xsm,
                    ),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      tag,
                      style: AppText.subtextBold.copyWith(color: accent),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
