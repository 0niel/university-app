import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';

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
    final colors = context.ninja;
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        8,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: Semantics(
        button: true,
        child: AppPressable(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: .circular(NinjaRadius.card),
            ),
            padding: const .all(14),
            child: Row(
              children: [
                NinjaAvatar(
                  initials: ninjaInitials(name),
                  size: 52,
                  tone: NinjaAvatarTone.indigo,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: NinjaText.body.copyWith(
                          color: colors.ink,
                          fontWeight: .w700,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: .ellipsis,
                          style: NinjaText.subtext.copyWith(
                            color: colors.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 44,
                  height: 44,
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: colors.brandTint,
                    borderRadius: .circular(14),
                  ),
                  child: AppLineIconWidget(
                    .pencil,
                    size: 19,
                    color: colors.brandInk,
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
