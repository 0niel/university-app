import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class PostTimestamp extends StatelessWidget {
  const PostTimestamp({
    required this.publishedAt,
    super.key,
    this.isContentOverlaid = false,
    this.iconSize = 14,
  });

  final DateTime publishedAt;
  final bool isContentOverlaid;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final scale = Theme.of(context).scale;
    final color =
        isContentOverlaid
            ? colors.white.withValues(alpha: 0.8)
            : colors.onSurface.withValues(alpha: 0.6);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.schedule_outlined, size: scale.icon(iconSize), color: color),
        SizedBox(width: scale.space(AppSpacing.xs)),
        Text(
          formatPostTime(publishedAt),
          style: AppText.caption.copyWith(color: color),
        ),
      ],
    );
  }
}

String formatPostTime(DateTime dateTime) {
  final difference = DateTime.now().difference(dateTime);
  if (difference.inMinutes < 1) return 'только что';
  if (difference.inMinutes < 60) return '${difference.inMinutes} мин назад';
  if (difference.inHours < 24) return '${difference.inHours} ч назад';
  if (difference.inDays < 7) return '${difference.inDays} д назад';

  final month = dateTime.month.toString().padLeft(2, '0');
  return '${dateTime.day}.$month.${dateTime.year}';
}
