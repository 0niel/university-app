import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/profile_progress_bar.dart';

class BadgeTile extends StatelessWidget {
  const BadgeTile({required this.badge, super.key});

  final GamificationBadge badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final isEarned = badge.isEarned;
    final percent = (badge.progress * 100).round().clamp(0, 99);

    return Semantics(
      label: badge.name,
      value: isEarned
          ? '${l10n.profileBadgeEarned}, ${badge.category}'
          : '${l10n.profileBadgeLocked}, $percent%',
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        clipBehavior: .antiAlias,
        child: Padding(
          padding: const .fromLTRB(10, 14, 10, 12),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: isEarned ? colors.brandTint : colors.surfaceAlt,
                    shape: .circle,
                  ),
                  child: Opacity(
                    opacity: isEarned ? 1 : 0.45,
                    child: Text(
                      badge.emoji,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                badge.name,
                textAlign: .center,
                maxLines: 2,
                overflow: .ellipsis,
                style: NinjaText.helper.copyWith(
                  color: isEarned ? colors.ink : colors.mutedDark,
                  fontWeight: .w700,
                ),
              ),
              const SizedBox(height: 3),
              Flexible(
                child: Text(
                  badge.description,
                  textAlign: .center,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: NinjaText.helper.copyWith(color: colors.muted),
                ),
              ),
              const SizedBox(height: 8),
              if (isEarned)
                Text(
                  l10n.profileBadgeEarned,
                  textAlign: .center,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: NinjaText.helper.copyWith(
                    color: colors.brandInk,
                    fontWeight: .w700,
                  ),
                )
              else
                ProfileProgressBar(
                  value: badge.progress.clamp(0.0, 1.0),
                  label: '$percent%',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
