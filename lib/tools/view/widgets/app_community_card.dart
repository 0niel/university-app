import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppCommunityCard extends StatelessWidget {
  const AppCommunityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final iconTile = Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.brandTint,
        borderRadius: .circular(NinjaRadius.button),
      ),
      child: IconTheme.merge(
        data: IconThemeData(color: colors.brand, size: 20),
        child: icon,
      ),
    );
    final labels = Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      spacing: 2,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: .ellipsis,
          style: NinjaText.headline.copyWith(
            color: colors.ink,
            fontWeight: .w600,
          ),
        ),
        Text(
          subtitle,
          maxLines: 2,
          overflow: .ellipsis,
          style: NinjaText.subtext.copyWith(color: colors.muted),
        ),
      ],
    );
    return Semantics(
      button: true,
      label: title,
      child: AppPressable(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(NinjaRadius.card),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const .all(16),
              child: Row(
                children: [
                  iconTile,
                  const SizedBox(width: 14),
                  Expanded(child: labels),
                  const SizedBox(width: 10),
                  AppLineIconWidget(
                    .chevronR,
                    size: 16,
                    color: colors.chevron,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
