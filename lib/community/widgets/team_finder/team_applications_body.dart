import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/team_applications/team_applications.dart';
import 'package:rtu_mirea_app/community/widgets/team_finder/team_application_card.dart';
import 'package:rtu_mirea_app/community/widgets/team_finder/team_applications_skeleton.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class TeamApplicationsBody extends StatelessWidget {
  const TeamApplicationsBody({
    required this.onTelegram,
    required this.onChanged,
    super.key,
  });

  final ValueChanged<TeamApplication> onTelegram;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TeamApplicationsCubit>().state;
    return NinjaStateSwitcher(child: _content(context, state));
  }

  Widget _content(BuildContext context, TeamApplicationsState state) {
    if (state.status == .loading && state.applications.isEmpty) {
      return const TeamApplicationsSkeleton(
        key: ValueKey('applications-loading'),
      );
    }
    if (state.status == .failure && state.applications.isEmpty) {
      return AppErrorState(
        key: const ValueKey('applications-failure'),
        title: context.l10n.teamFinderApplicationsLoadError,
        message: context.l10n.teamFinderApplicationsLoadErrorSubtitle,
        primaryLabel: context.l10n.retry,
        onPrimary: () =>
            unawaited(context.read<TeamApplicationsCubit>().load()),
      );
    }
    if (state.applications.isEmpty) {
      return AppEmptyState(
        key: const ValueKey('applications-empty'),
        title: context.l10n.teamFinderApplicationsEmptyTitle,
        subtitle: context.l10n.teamFinderApplicationsEmptySubtitle,
        actionLabel: context.l10n.retry,
        onAction: () => unawaited(context.read<TeamApplicationsCubit>().load()),
      ).animateEmptyState();
    }
    return ListView.builder(
      key: const ValueKey('applications-list'),
      shrinkWrap: true,
      itemCount: state.applications.length,
      itemBuilder: (context, index) {
        final application = state.applications[index];
        return TeamApplicationCard(
          application: application,
          isBusy: state.pendingIds.contains(application.id),
          isRejecting: state.pendingRejectIds.contains(application.id),
          onAccept: () => unawaited(_act(context, application, .accept)),
          onReject: () => unawaited(_act(context, application, .reject)),
          onTelegram: _hasContact(application)
              ? () => onTelegram(application)
              : null,
        ).animateListItem(key: ValueKey(application.id), index: index);
      },
    );
  }

  Future<void> _act(
    BuildContext context,
    TeamApplication application,
    TeamApplicationAction action,
  ) async {
    final changed = await context.read<TeamApplicationsCubit>().act(
      application.id,
      action,
    );
    if (!context.mounted) return;
    if (changed) {
      onChanged();
    } else {
      ToastManager.showError(
        context,
        message: context.l10n.teamFinderApplicationActionError,
      );
    }
  }

  bool _hasContact(TeamApplication application) =>
      application.attachProfile &&
      (application.applicantHandle?.isNotEmpty ?? false);
}
