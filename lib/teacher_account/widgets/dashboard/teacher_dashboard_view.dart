import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/teacher_dashboard_bloc.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_dashboard_binding.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_navigation.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/account_persona_sheet.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_account_sync_banner.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_dashboard_content.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_dashboard_header.dart';

class TeacherDashboardView extends StatelessWidget {
  const TeacherDashboardView({super.key});

  void _navigate(BuildContext context, TeacherDashboardState state) {
    final navigation = state.navigation;
    if (navigation is TeacherNavigationReady) {
      context.read<TeacherDashboardBloc>().add(
        const TeacherDashboardEvent.navigationHandled(),
      );
      switch (navigation.destination) {
        case TeacherScheduleDestination.schedule:
          context.go('/schedule');
        case TeacherScheduleDestination.changes:
          context.go('/schedule/changes');
        case TeacherScheduleDestination.calendar:
          unawaited(showScheduleExportSheet(context));
      }
    } else if (navigation is TeacherNavigationFailure) {
      ToastManager.showError(
        context,
        message: context.l10n.scheduleLoadingError,
      );
      context.read<TeacherDashboardBloc>().add(
        const TeacherDashboardEvent.navigationHandled(),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colors.canvas,
    body: BlocConsumer<TeacherDashboardBloc, TeacherDashboardState>(
      listenWhen: (previous, current) =>
          previous.navigation != current.navigation,
      listener: _navigate,
      buildWhen: (previous, current) => previous.binding != current.binding,
      builder: (context, state) => RefreshIndicator(
        onRefresh: context.read<TeacherDashboardBloc>().refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: ninjaBottomInset(context) + AppSpacing.lg,
          ),
          children: [
            TeacherDashboardHeader(
              onBack: () =>
                  context.canPop() ? context.pop() : context.go('/profile'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TeacherAccountSyncBanner(),
                  switch (state.binding) {
                    TeacherBindingReady() => const TeacherDashboardContent(),
                    TeacherBindingRestoring() => AppSkeletonGroup(
                      semanticsLabel: context.l10n.loadingContent,
                      child: const AppSkeleton(
                        height: 220,
                        radius: AppRadius.card,
                      ),
                    ),
                    final binding => AppEmptyState(
                      lineIcon: AppLineIcon.user,
                      title: binding is TeacherBindingUnavailable
                          ? context.l10n.teacherUnavailableTitle
                          : context.l10n.teacherChooseTitle,
                      subtitle: binding is TeacherBindingUnavailable
                          ? context.l10n.teacherUnavailableDescription
                          : context.l10n.teacherChooseDescription,
                      actionLabel: context.l10n.teacherChooseTitle,
                      onAction: () => unawaited(
                        showAccountPersonaSheet(
                          context,
                          initialRole: AccountRole.teacher,
                        ),
                      ),
                    ),
                  },
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
