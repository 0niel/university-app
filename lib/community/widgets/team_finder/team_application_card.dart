import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
import 'package:rtu_mirea_app/community/view/team_finder_labels.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class TeamApplicationCard extends StatelessWidget {
  const TeamApplicationCard({
    required this.application,
    required this.onAccept,
    required this.onReject,
    super.key,
    this.onTelegram,
    this.isBusy = false,
    this.isRejecting = false,
  });

  final TeamApplication application;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback? onTelegram;
  final bool isBusy;
  final bool isRejecting;

  @override
  Widget build(BuildContext context) {
    final metadata = <String>[
      if (application.role.isNotEmpty)
        teamRoleLabel(context.l10n, application.role),
      ?application.applicantGroup,
    ].join(' · ');
    final colors = context.ninja;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(NinjaRadius.card),
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
                  NinjaAvatar(
                    initials: ninjaInitials(application.applicantName),
                    size: 40,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          application.applicantName,
                          style: NinjaText.body.copyWith(color: colors.ink),
                        ),
                        if (metadata.isNotEmpty)
                          Text(
                            metadata,
                            style: NinjaText.helper.copyWith(
                              color: colors.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!application.attachProfile)
                    NinjaBadge(
                      context.l10n.teamFinderContactHidden,
                      tone: .ink,
                    ),
                ],
              ),
              if (application.message.isNotEmpty)
                Text(
                  application.message,
                  style: NinjaText.subtext.copyWith(
                    color: colors.muted,
                    height: 1.4,
                  ),
                ),
              NinjaButton.primary(
                label: isBusy
                    ? context.l10n.teamFinderAccepting
                    : context.l10n.teamFinderAcceptApplication,
                expanded: true,
                loading: isBusy && !isRejecting,
                onPressed: isBusy ? null : onAccept,
              ),
              NinjaButton.destructive(
                label: context.l10n.teamFinderRejectApplication,
                expanded: true,
                loading: isRejecting,
                onPressed: isBusy ? null : onReject,
              ),
              if (onTelegram != null)
                NinjaButton.secondary(
                  label: context.l10n.teamFinderWriteTelegram,
                  expanded: true,
                  onPressed: isBusy ? null : onTelegram,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
