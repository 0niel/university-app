import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ProfileShortcut extends StatelessWidget {
  const ProfileShortcut({
    required this.name,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final String name;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const .fromLTRB(
        AppSpacing.screen,
        8,
        AppSpacing.screen,
        0,
      ),
      child: Semantics(
        button: true,
        child: AppPressable(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: .circular(AppRadius.card),
            ),
            padding: const .all(AppSpacing.sectionGap),
            child: Row(
              children: [
                AppAvatar(
                  name: name,
                  size: AppControlSize.buttonLarge,
                  color: colors.onAccent,
                  backgroundColor: colors.accent,
                ),
                const SizedBox(width: AppSpacing.sectionGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: AppText.body.copyWith(
                          color: colors.ink,
                          fontWeight: .w700,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: .ellipsis,
                          style: AppText.subtext.copyWith(
                            color: colors.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Container(
                  width: AppControlSize.iconButton,
                  height: AppControlSize.iconButton,
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: colors.tint,
                    borderRadius: .circular(AppRadius.tile),
                  ),
                  child: AppLineIconWidget(
                    .pencil,
                    size: 19,
                    color: colors.accent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
