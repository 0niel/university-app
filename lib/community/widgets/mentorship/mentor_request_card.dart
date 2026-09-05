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
      if (request.topic.isNotEmpty)
        mentorTopicLabel(context.l10n, request.topic),
      mentorWhenShortLabel(context.l10n, request.whenSlot.wireValue),
    ].join(' · ');
    return AppCard(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        10,
      ),
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
          AppBadge(
            label: switch (request.status) {
              .pending => context.l10n.mentorshipPending,
              .accepted => context.l10n.mentorshipAccepted,
              .completionPending => context.l10n.mentorshipWaitingConfirmation,
              .completed => context.l10n.mentorshipCompleted,
              .declined => context.l10n.mentorshipDeclined,
              .cancelled => context.l10n.mentorshipCancelled,
            },
            tone: .ink,
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
    );
  }

  List<Widget> _actions(BuildContext context) {
    if (request.status == .pending && request.isIncoming) {
      return [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppButton.primary(
              label: context.l10n.mentorshipAcceptRequest,
              size: AppButtonSize.small,
              loading: isDismissing,
              onPressed: isDismissing ? null : () => onAction(.accept),
            ),
            AppButton.text(
              label: context.l10n.mentorshipDeclineRequest,
              size: AppButtonSize.small,
              foregroundColor: context.colors.danger,
              onPressed: isDismissing ? null : () => onAction(.decline),
            ),
          ],
        ),
      ];
    }
    if (request.status == .pending) {
      return [
        AppButton.text(
          label: context.l10n.mentorshipCancelRequest,
          size: AppButtonSize.small,
          foregroundColor: context.colors.danger,
          onPressed: isDismissing ? null : () => onAction(.cancel),
        ),
      ];
    }
    if (request.status == .accepted || request.status == .completionPending) {
      return [
        if (!request.hasConfirmed)
          AppButton.primary(
            label: context.l10n.mentorshipConfirmComplete,
            expanded: true,
            loading: isDismissing,
            onPressed: isDismissing || request.hasConfirmed
                ? null
                : () => onAction(.confirmComplete),
          ),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            if (request.replyTelegramHandle?.isNotEmpty ?? false)
              AppButton.tonal(
                label: context.l10n.mentorshipReplyTelegram,
                size: AppButtonSize.small,
                onPressed: isDismissing ? null : onReply,
              ),
            if (request.status == .accepted || request.hasConfirmed)
              AppButton.text(
                label: context.l10n.mentorshipCancelRequest,
                size: AppButtonSize.small,
                foregroundColor: context.colors.danger,
                onPressed: isDismissing ? null : () => onAction(.cancel),
              ),
          ],
        ),
      ];
    }
    return const [];
  }
}
