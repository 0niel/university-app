import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/community.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaGroupSpaceHero extends StatelessWidget {
  const NinjaGroupSpaceHero({required this.space, super.key});

  final GroupSpace space;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const .symmetric(horizontal: AppSpacing.screen),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Padding(
          padding: const .all(16),
          child: Row(
            spacing: 14,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.tint,
                  borderRadius: .circular(AppRadius.tile),
                ),
                child: Text(space.emoji, style: const TextStyle(fontSize: 21)),
              ),
              Expanded(
                child: Column(
                  spacing: 6,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      space.group ?? context.l10n.groupSpaceMyGroup,
                      maxLines: 2,
                      overflow: .ellipsis,
                      style: AppText.title.copyWith(color: colors.ink),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: .center,
                      children: [
                        TeamAvatarStack(names: space.memberNames, size: 26),
                        Text(
                          context.l10n.groupSpaceMembers(space.memberCount),
                          style: AppText.caption.copyWith(
                            fontWeight: .w700,
                            color: colors.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
