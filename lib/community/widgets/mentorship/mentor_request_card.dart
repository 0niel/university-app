import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/community/view/mentorship_labels.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MentorRequestCard extends StatelessWidget {
  const MentorRequestCard({
    required this.request,
    required this.onReply,
    required this.onAction,
    super.key,
    this.isDismissing = false,
  });

  final MentorRequest request;
  final VoidCallback onReply;
  final ValueChanged<MentorRequestAction> onAction;
  final bool isDismissing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final metadata = [
      if (request.topic.isNotEmpty) request.topic,
      mentorWhenShortLabel(context.l10n, request.whenSlot.wireValue),
    ].join(' · ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        10,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 10,
            crossAxisAlignment: .start,
            children: [
              Row(
                spacing: 12,
                children: [
                  NinjaAvatar(initials: ninjaInitials(request.counterpartName)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          request.counterpartName,
                          style: AppText.body.copyWith(color: colors.ink),
                        ),
                        Text(
                          metadata,
                          style: AppText.captionSmall.copyWith(
                            color: colors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (request.message.isNotEmpty)
                Text(
                  request.message,
                  style: AppText.subtext.copyWith(
                    color: colors.muted,
                    height: 1.4,
                  ),
                ),
              ..._actions(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _actions(BuildContext context) {
    if (request.status == .pending && request.isIncoming) {
      return [
        NinjaButton.primary(
          label: context.l10n.mentorshipAcceptRequest,
          expanded: true,
          onPressed: isDismissing ? null : () => onAction(.accept),
        ),
        NinjaButton.destructive(
          label: context.l10n.mentorshipDeclineRequest,
          expanded: true,
          onPressed: isDismissing ? null : () => onAction(.decline),
        ),
      ];
    }
    if (request.status == .pending) {
      return [
        if (request.status == .accepted || request.hasConfirmed)
          NinjaButton.destructive(
            label: context.l10n.mentorshipCancelRequest,
            expanded: true,
            onPressed: isDismissing ? null : () => onAction(.cancel),
          ),
      ];
    }
    if (request.status == .accepted || request.status == .completionPending) {
      return [
        NinjaButton.secondary(
          label: context.l10n.mentorshipReplyTelegram,
          expanded: true,
          onPressed: (request.counterpartHandle?.isNotEmpty ?? false)
              ? onReply
              : null,
        ),
        NinjaButton.primary(
          label: request.hasConfirmed
              ? context.l10n.mentorshipWaitingConfirmation
              : context.l10n.mentorshipConfirmComplete,
          expanded: true,
          onPressed: isDismissing || request.hasConfirmed
              ? null
              : () => onAction(.confirmComplete),
        ),
        NinjaButton.destructive(
          label: context.l10n.mentorshipCancelRequest,
          expanded: true,
          onPressed: isDismissing ? null : () => onAction(.cancel),
        ),
      ];
    }
    final label = switch (request.status) {
      .completed => context.l10n.mentorshipCompleted,
      .declined => context.l10n.mentorshipDeclined,
      .cancelled => context.l10n.mentorshipCancelled,
      .pending || .accepted || .completionPending => throw StateError(
        'Interactive request status reached the terminal status branch',
      ),
    };
    return [NinjaBadge(label, tone: .ink)];
  }
}
