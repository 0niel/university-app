import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/search/widgets/highlighted_title.dart';

class SearchBestMatchCard extends StatelessWidget {
  const SearchBestMatchCard({
    required this.name,
    required this.query,
    required this.tagLabel,
    required this.onPressed,
    super.key,
    this.subtitle,
  });

  final String name;
  final String query;
  final String tagLabel;
  final String? subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitleText = subtitle;
    return AppPressable(
      onTap: onPressed,
      semanticsLabel: '$tagLabel, $name',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.tint,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.ink.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(AppRadius.field),
                    ),
                    child: SizedBox.square(
                      dimension: 44,
                      child: Center(
                        child: AppLineIconWidget(
                          AppLineIcon.focus,
                          size: 20,
                          color: colors.ink,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      tagLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body.copyWith(
                        color: colors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.ink.withValues(alpha: .12),
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox.square(
                      dimension: 44,
                      child: Center(
                        child: AppLineIconWidget(
                          AppLineIcon.arrowRight,
                          size: 18,
                          color: colors.ink,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              HighlightedTitle(
                name: name,
                query: query,
                baseColor: colors.muted,
                highlightColor: colors.ink,
              ),
              if (subtitleText != null && subtitleText.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  subtitleText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body.copyWith(
                    color: colors.muted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
