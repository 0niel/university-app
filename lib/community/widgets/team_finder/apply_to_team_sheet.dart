import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/team_finder/team_finder.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/view/team_finder_labels.dart';
import 'package:rtu_mirea_app/community/widgets/team_finder/team_choice_chip.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ApplyToTeamSheet extends StatefulWidget {
  const ApplyToTeamSheet({required this.team, super.key});

  final Team team;

  @override
  State<ApplyToTeamSheet> createState() => _ApplyToTeamSheetState();
}

class _ApplyToTeamSheetState extends State<ApplyToTeamSheet> {
  final _message = TextEditingController();
  late String _role = widget.team.neededRoles.firstOrNull ?? '';
  var _attachProfile = true;
  var _submitted = false;
  var _failed = false;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => _submitted = true);
    if (widget.team.neededRoles.isNotEmpty && _role.isEmpty) return;
    setState(() => _failed = false);
    final sent = await context.read<TeamFinderCubit>().apply(
      TeamApplicationDraft(
        teamId: widget.team.id,
        role: _role,
        message: _message.text,
        attachProfile: _attachProfile,
      ),
    );
    if (!mounted) return;
    if (sent) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final sending = context.select<TeamFinderCubit, bool>(
      (cubit) => cubit.state.pendingApplyIds.contains(widget.team.id),
    );
    final roleInvalid =
        _submitted && widget.team.neededRoles.isNotEmpty && _role.isEmpty;

    return SingleChildScrollView(
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_failed)
            AppBanner(
              message: l10n.teamFinderApplyError,
              tone: AppBannerTone.danger,
            ),
          _summary(context),
          if (widget.team.neededRoles.isNotEmpty) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppFieldLabel(l10n.teamFinderApplyRoleLabel),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final role in widget.team.neededRoles)
                      TeamChoiceChip(
                        enabled: !sending,
                        label: teamRoleLabel(context.l10n, role),
                        selected: _role == role,
                        onPressed: () => setState(() => _role = role),
                      ),
                  ],
                ),
                if (roleInvalid) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.teamFinderCreateRolesError,
                    style: AppText.caption.copyWith(color: colors.danger),
                  ),
                ],
              ],
            ),
          ],
          AppInputField.multiline(
            controller: _message,
            minLines: 2,
            maxLength: 2000,
            enabled: !sending,
            label: l10n.teamFinderApplyAboutLabel,
            placeholder: l10n.teamFinderApplyAboutHint,
          ),
          AppListGroup(
            children: [
              AppSettingsToggleRow(
                title: l10n.teamFinderApplyAttachProfile,
                subtitle: l10n.teamFinderApplyAttachProfileHint,
                value: _attachProfile,
                isFirst: true,
                onChanged: sending
                    ? null
                    : (value) => setState(() => _attachProfile = value),
              ),
            ],
          ),
          AppButton.primary(
            label: sending
                ? l10n.teamFinderSending
                : l10n.teamFinderSendApplication,
            expanded: true,
            size: AppButtonSize.large,
            loading: sending,
            onPressed: sending ? null : () => unawaited(_send()),
          ),
        ],
      ),
    );
  }

  Widget _summary(BuildContext context) {
    final l10n = context.l10n;
    final team = widget.team;
    final rolesSuffix = team.neededRoles.isEmpty
        ? ''
        : l10n.teamFinderApplyNeededRoles(
            team.neededRoles
                .map((role) => teamRoleLabel(l10n, role))
                .join(', '),
          );
    return AppCard(
      child: Row(
        spacing: 12,
        children: [
          AppAvatar(name: team.memberNames.firstOrNull ?? team.title, size: 42),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(team.title, style: AppText.body),
                Text(
                  l10n.teamFinderApplyMembersInfo(
                    team.memberCount,
                    team.capacity,
                    rolesSuffix,
                  ),
                  style: AppText.captionSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
