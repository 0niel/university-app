import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/team_finder/team_finder.dart';
import 'package:rtu_mirea_app/community/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamFinderView extends StatelessWidget {
  const TeamFinderView({super.key});

  Future<void> _create(BuildContext context) async {
    final cubit = context.read<TeamFinderCubit>();
    await showAppSheet<void>(
      context,
      title: context.l10n.teamFinderCreateSheetTitle,
      subtitle: context.l10n.teamFinderCreateSheetSubtitle,
      child: BlocProvider.value(value: cubit, child: const CreateTeamSheet()),
    );
  }

  Future<void> _apply(BuildContext context, Team team) async {
    final cubit = context.read<TeamFinderCubit>();
    final sent = await showAppSheet<bool>(
      context,
      title: context.l10n.teamFinderApplySheetTitle,
      subtitle: team.title,
      child: BlocProvider.value(
        value: cubit,
        child: ApplyToTeamSheet(team: team),
      ),
    );
    if (sent == true && context.mounted) {
      showNinjaToast(
        context,
        message: context.l10n.teamFinderApplicationSent,
      );
    }
  }

  Future<void> _applications(BuildContext context, Team team) async {
    final cubit = context.read<TeamFinderCubit>();
    await showAppSheet<void>(
      context,
      title: context.l10n.teamFinderApplicationsSheetTitle(team.title),
      child: TeamApplicationsSheet(
        team: team,
        onTelegram: (application) =>
            unawaited(_openTelegram(context, application)),
        onChanged: () => unawaited(cubit.load()),
      ),
    );
  }

  Future<void> _openTelegram(
    BuildContext context,
    TeamApplication application,
  ) async {
    final rawHandle = application.applicantHandle ?? '';
    final handle = rawHandle.trim().replaceFirst(RegExp('^@'), '');
    if (!RegExp(r'^[A-Za-z0-9_]{5,32}$').hasMatch(handle)) {
      _showError(context, context.l10n.teamFinderTelegramUnavailable);
      return;
    }
    final opened = await launchUrl(
      Uri.https('t.me', '/$handle'),
      mode: .externalApplication,
    );
    if (!opened && context.mounted) {
      _showError(context, context.l10n.teamFinderTelegramOpenError);
    }
  }

  Future<void> _withdraw(BuildContext context, Team team) async {
    final confirmed = await showNinjaConfirmDialog(
      context,
      title: context.l10n.teamFinderWithdrawConfirmTitle,
      message: context.l10n.teamFinderWithdrawConfirmBody,
      confirmLabel: context.l10n.teamFinderWithdrawApplication,
      cancelLabel: context.l10n.collabNotesCancel,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final changed = await context.read<TeamFinderCubit>().withdraw(team);
    if (!changed && context.mounted) {
      _showError(context, context.l10n.teamFinderApplicationActionError);
    }
  }

  Future<void> _leave(BuildContext context, Team team) async {
    final confirmed = await showNinjaConfirmDialog(
      context,
      title: context.l10n.teamFinderLeaveConfirmTitle,
      message: context.l10n.teamFinderLeaveConfirmBody,
      confirmLabel: context.l10n.teamFinderLeaveTeam,
      cancelLabel: context.l10n.collabNotesCancel,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final changed = await context.read<TeamFinderCubit>().leave(team.id);
    if (!changed && context.mounted) {
      _showError(context, context.l10n.teamFinderLeaveError);
    }
  }

  Future<void> _delete(BuildContext context, Team team) async {
    final confirmed = await showNinjaConfirmDialog(
      context,
      title: context.l10n.teamFinderDeleteConfirmTitle,
      message: context.l10n.teamFinderDeleteConfirmBody,
      confirmLabel: context.l10n.teamFinderDeleteTeam,
      cancelLabel: context.l10n.collabNotesCancel,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final deleted = await context.read<TeamFinderCubit>().delete(team.id);
    if (!deleted && context.mounted) {
      _showError(context, context.l10n.teamFinderDeleteError);
    }
  }

  void _showError(BuildContext context, String message) {
    showNinjaToast(context, showCheck: false, message: message);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeamFinderCubit, TeamFinderState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == .failure &&
          current.teams.isNotEmpty,
      listener: (context, _) =>
          _showError(context, context.l10n.teamFinderRefreshError),
      builder: (context, _) => Scaffold(
        backgroundColor: context.ninja.canvas,
        floatingActionButton: NinjaCommunityFab(
          label: context.l10n.teamFinderCreateCta,
          onPressed: () => unawaited(_create(context)),
        ),
        body: Column(
          children: [
            NinjaCommunityHeader(
              title: context.l10n.teamFinderTitle,
              subtitle: context.l10n.teamFinderSubtitle,
            ),
            Expanded(
              child: TeamFinderBody(
                onCreate: () => unawaited(_create(context)),
                onApply: (team) => unawaited(_apply(context, team)),
                onWithdraw: (team) => unawaited(_withdraw(context, team)),
                onLeave: (team) => unawaited(_leave(context, team)),
                onApplications: (team) =>
                    unawaited(_applications(context, team)),
                onDelete: (team) => unawaited(_delete(context, team)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
