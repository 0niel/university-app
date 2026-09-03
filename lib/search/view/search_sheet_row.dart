import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class SearchSheetHit {
  const SearchSheetHit({
    required this.kind,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final String kind;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
}

class SearchSheetRow extends StatelessWidget {
  const SearchSheetRow({required this.hit, super.key});

  final SearchSheetHit hit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitle = hit.subtitle;
    return AppPressable(
      onTap: hit.onTap,
      pressedScale: 1,
      semanticsButton: true,
      semanticsLabel: [hit.kind, hit.title, ?subtitle].join(', '),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 13,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 76,
              child: Text(
                hit.kind,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.sans(
                  10.5,
                  FontWeight.w800,
                  letterSpacingEm: .04,
                ).copyWith(color: colors.muted),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hit.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.cell.copyWith(color: colors.ink),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption.copyWith(color: colors.muted),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: AppIconSize.sm,
              color: colors.muted2,
            ),
          ],
        ),
      ),
    );
  }
}

class SearchRecentPill extends StatelessWidget {
  const SearchRecentPill({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressState(
      onTap: onTap,
      semanticsButton: true,
      semanticsLabel: label,
      builder: (context, {required pressed}) => ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppControlSize.touchTarget,
        ),
        child: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sectionGap,
              vertical: AppSpacing.gap,
            ),
            decoration: BoxDecoration(
              color: pressed ? colors.canvas : colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              label,
              style: AppText.sans(
                13,
                FontWeight.w600,
              ).copyWith(color: colors.ink),
            ),
          ),
        ),
      ),
    );
  }
}
