import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/search/widgets/item_type.dart';

export 'item_type.dart';

class SearchResultItem extends StatelessWidget {
  const SearchResultItem({
    required this.name,
    required this.onPressed,
    required this.type,
    super.key,
    this.subtitle,
    this.tagLabel,
  });

  final String name;
  final ItemType type;
  final String? subtitle;
  final String? tagLabel;
  final VoidCallback onPressed;

  AppLineIcon get _icon => switch (type) {
    .group => AppLineIcon.people,
    .teacher || .person => AppLineIcon.user,
    .classroom => AppLineIcon.pin,
    .post => AppLineIcon.message,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tag = tagLabel;
    final subtitleText = subtitle;
    return AppPressable(
      onTap: onPressed,
      semanticsLabel: [name, ?tag, ?subtitleText].join(', '),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.tint,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: SizedBox.square(
                dimension: 42,
                child: Center(
                  child: AppLineIconWidget(
                    _icon,
                    size: 19,
                    color: colors.accent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body.copyWith(
                      color: colors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitleText != null && subtitleText.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitleText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.subtext.copyWith(
                        color: colors.muted,
                      ),
                    ),
                  ] else if (tag != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      tag,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.subtext.copyWith(
                        color: colors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: 16,
              color: colors.muted2,
            ),
          ],
        ),
      ),
    );
  }
}
