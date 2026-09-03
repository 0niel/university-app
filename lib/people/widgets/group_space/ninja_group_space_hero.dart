import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/community/community.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaGroupSpaceHero extends StatelessWidget {
  const NinjaGroupSpaceHero({
    required this.space,
    required this.onlineCount,
    required this.onInvite,
    super.key,
  });

  final GroupSpace space;
  final int onlineCount;
  final VoidCallback onInvite;

  Future<void> _copyCode(BuildContext context) async {
    final code = space.joinCode;
    if (code == null || code.isEmpty) return;
    try {
      await Clipboard.setData(ClipboardData(text: code));
    } on Exception {
      return;
    }
    if (context.mounted) {
      showNinjaToast(context, message: context.l10n.studyGroupCodeCopied);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final joinCode = space.joinCode;
    return Padding(
      padding: const .symmetric(horizontal: AppSpacing.screen),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Padding(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
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
                    child: Text(
                      space.emoji,
                      style: const TextStyle(fontSize: 21),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      spacing: 6,
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            Expanded(
                              child: Text(
                                space.group ?? l10n.groupSpaceMyGroup,
                                maxLines: 2,
                                overflow: .ellipsis,
                                style: AppText.title.copyWith(
                                  color: colors.ink,
                                ),
                              ),
                            ),
                            NinjaBadge(
                              space.isOwner
                                  ? l10n.studyGroupOwnerTag
                                  : l10n.studyGroupYouTag,
                              tone: space.isOwner ? .lime : .ink,
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: .center,
                          children: [
                            TeamAvatarStack(names: space.memberNames, size: 26),
                            Text(
                              l10n.groupSpaceMembers(space.memberCount),
                              style: AppText.caption.copyWith(
                                fontWeight: .w700,
                                color: colors.muted,
                              ),
                            ),
                            if (onlineCount > 0)
                              AppBadge(
                                dot: true,
                                label: l10n.groupSpaceOnlineCount(onlineCount),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (joinCode != null && joinCode.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: AppPressable(
                        onTap: () => unawaited(_copyCode(context)),
                        semanticsLabel: '${l10n.studyGroupShareCode} $joinCode',
                        semanticsButton: true,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.surface2,
                            borderRadius: .circular(AppRadius.checkbox),
                          ),
                          child: Padding(
                            padding: const .symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: .min,
                              spacing: 8,
                              children: [
                                AppLineIconWidget(
                                  .qr,
                                  size: 15,
                                  color: colors.muted,
                                ),
                                Text(
                                  joinCode,
                                  style: AppText.tabular(
                                    AppText.caption.copyWith(
                                      fontWeight: .w700,
                                      color: colors.ink,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    NinjaIconButton(
                      icon: AppLineIconWidget(
                        .share,
                        size: 17,
                        color: colors.ink,
                      ),
                      tooltip: l10n.studyGroupInviteAction,
                      onPressed: onInvite,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
