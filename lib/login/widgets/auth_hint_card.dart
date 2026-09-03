import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class AuthHintCard extends StatelessWidget {
  const AuthHintCard({
    required this.icon,
    required this.color,
    required this.title,
    super.key,
    this.subtitle,
    this.radius = AppRadius.card,
  });

  final AppLineIcon icon;
  final Color color;
  final String title;
  final String? subtitle;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitle = this.subtitle;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        child: Row(
          children: [
            AppIconTile(
              icon: icon,
              size: 40,
              radius: AppRadius.tile,
              background: colors.tintOf(color),
              foreground: color,
              iconSize: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.headline.copyWith(color: colors.ink),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppText.sans(
                        13,
                        FontWeight.w500,
                      ).copyWith(color: colors.muted),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
