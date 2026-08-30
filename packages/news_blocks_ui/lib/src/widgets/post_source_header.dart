import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class PostSourceHeader extends StatelessWidget {
  const PostSourceHeader({
    super.key,
    this.author,
    this.fallbackTitle = 'Новости',
  });

  final String? author;
  final String fallbackTitle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final scale = Theme.of(context).scale;
    final title =
        (author?.trim().isNotEmpty ?? false) ? author! : fallbackTitle;
    return Row(
      children: [
        Container(
          width: scale.size(24),
          height: scale.size(24),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.campaign_outlined,
            size: scale.icon(14),
            color: colors.primary,
          ),
        ),
        SizedBox(width: scale.space(AppSpacing.sm)),
        Expanded(
          child: Text(
            title,
            style: AppText.caption.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
