import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaGroupNoteCard extends StatelessWidget {
  const NinjaGroupNoteCard({
    required this.note,
    required this.pending,
    required this.onLike,
    super.key,
  });

  final GroupNote note;
  final bool pending;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Padding(
          padding: const .fromLTRB(16, 14, 8, 4),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  NinjaAvatar(
                    initials: ninjaInitials(note.authorName),
                    size: 32,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      note.authorName,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: NinjaText.helper.copyWith(color: colors.muted),
                    ),
                  ),
                  if (note.isPinned) ...[
                    const SizedBox(width: 8),
                    NinjaBadge(context.l10n.groupSpaceNotePinned),
                  ],
                  const SizedBox(width: 12),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const .only(right: 12),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      note.title,
                      style: NinjaText.headline.copyWith(color: colors.ink),
                    ),
                    if (note.body.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        note.body,
                        maxLines: 4,
                        overflow: .ellipsis,
                        style: NinjaText.subtext.copyWith(
                          color: colors.muted,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: AnimatedOpacity(
                  opacity: pending ? 0.45 : 1,
                  duration: const Duration(milliseconds: 160),
                  child: Semantics(
                    button: true,
                    toggled: note.likedByMe,
                    enabled: !pending,
                    label: '${note.likes}',
                    child: AppPressable(
                      onTap: pending
                          ? null
                          : () {
                              unawaited(HapticFeedback.lightImpact());
                              onLike();
                            },
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: NinjaMetrics.minTouchTarget,
                          minHeight: NinjaMetrics.minTouchTarget,
                        ),
                        child: Row(
                          spacing: 4,
                          mainAxisSize: .min,
                          mainAxisAlignment: .center,
                          children: [
                            AppLineIconWidget(
                              .heart,
                              size: 18,
                              color: note.likedByMe
                                  ? colors.brandInk
                                  : colors.muted,
                            ),
                            Text(
                              '${note.likes}',
                              style: NinjaText.helper.copyWith(
                                color: note.likedByMe
                                    ? colors.brandInk
                                    : colors.muted,
                                fontWeight: .w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
