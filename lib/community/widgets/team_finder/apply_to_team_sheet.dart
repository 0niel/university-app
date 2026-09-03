import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/common/utils/ninja_initials.dart';
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

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
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
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.teamFinderApplyError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sending = context.select<TeamFinderCubit, bool>(
      (cubit) => cubit.state.pendingApplyIds.contains(widget.team.id),
    );
    return SingleChildScrollView(
      child: Column(
        spacing: 16,
        crossAxisAlignment: .start,
        children: [
          _summary(context),
          if (widget.team.neededRoles.isNotEmpty) ...[
            Text(
              context.l10n.teamFinderApplyRoleLabel,
              style: AppText.captionSmall.copyWith(
                color: context.colors.muted,
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final role in widget.team.neededRoles)
                  TeamChoiceChip(
                    label: teamRoleLabel(context.l10n, role),
                    selected: _role == role,
                    onPressed: () => setState(() => _role = role),
                  ),
              ],
            ),
          ],
          NinjaInput.multiline(
            controller: _message,
            minLines: 2,
            maxLines: 4,
            maxLength: 2000,
            enabled: !sending,
            label: context.l10n.teamFinderApplyAboutLabel,
            placeholder: context.l10n.teamFinderApplyAboutHint,
          ),
          NinjaListCell(
            title: context.l10n.teamFinderApplyAttachProfile,
            subtitle: context.l10n.teamFinderApplyAttachProfileHint,
            horizontalPadding: 0,
            showChevron: false,
            trailing: NinjaSwitch(
              value: _attachProfile,
              onChanged: sending
                  ? null
                  : (value) => setState(() => _attachProfile = value),
            ),
          ),
          NinjaButton.primary(
            label: sending
                ? context.l10n.teamFinderSending
                : context.l10n.teamFinderSendApplication,
            expanded: true,
            size: NinjaButtonSize.large,
            onPressed: sending ? null : () => unawaited(_send()),
          ),
        ],
      ),
    );
  }

  Widget _summary(BuildContext context) {
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Row(
        spacing: 12,
        children: [
          NinjaAvatar(
            initials: ninjaInitials(
              widget.team.memberNames.firstOrNull ?? widget.team.title,
            ),
            size: 42,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(widget.team.title, style: AppText.body),
                Text(
                  context.l10n.teamFinderApplyMembersInfo(
                    widget.team.memberCount,
                    widget.team.capacity,
                    '',
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
