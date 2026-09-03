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

  Future<void> _create(BuildContext context, {Team? editing}) async {
    final cubit = context.read<TeamFinderCubit>();
    final l10n = context.l10n;
    await showAppSheet<void>(
      context,
      title: editing == null
          ? l10n.teamFinderCreateSheetTitle
          : l10n.teamFinderEditSheetTitle,
      subtitle: editing == null ? l10n.teamFinderCreateSheetSubtitle : null,
      child: BlocProvider.value(
        value: cubit,
        child: CreateTeamSheet(editing: editing),
      ),
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
      ToastManager.showSuccess(
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
    final confirmed = await showAppConfirmDialog(
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
    final confirmed = await showAppConfirmDialog(
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
    final confirmed = await showAppConfirmDialog(
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

  Future<void> _closeToggle(BuildContext context, Team team) async {
    final l10n = context.l10n;
    final cubit = context.read<TeamFinderCubit>();
    if (team.status != TeamStatus.closed) {
      final confirmed = await showAppConfirmDialog(
        context,
        title: l10n.teamFinderCloseConfirmTitle,
        message: l10n.teamFinderCloseConfirmBody,
        confirmLabel: l10n.teamFinderCloseTeam,
        cancelLabel: l10n.collabNotesCancel,
        destructive: true,
      );
      if (!confirmed || !context.mounted) return;
      final closed = await cubit.closeTeam(team);
      if (!closed && context.mounted) {
        _showError(context, l10n.teamFinderCloseError);
      }
      return;
    }
    final reopened = await cubit.reopenTeam(team);
    if (!reopened && context.mounted) {
      _showError(context, l10n.teamFinderUpdateError);
    }
  }

  void _showError(BuildContext context, String message) {
    ToastManager.showError(context, message: message);
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
        backgroundColor: context.colors.canvas,
        floatingActionButton: AppFab.extended(
          icon: AppLineIcon.plus,
          label: context.l10n.teamFinderCreateCta,
          onPressed: () => unawaited(_create(context)),
        ),
        body: Column(
          children: [
            AppScreenHeader(
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
                onEdit: (team) => unawaited(_create(context, editing: team)),
                onCloseToggle: (team) => unawaited(_closeToggle(context, team)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
