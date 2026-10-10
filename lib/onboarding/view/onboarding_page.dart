import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_client/permission_client.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/onboarding/bloc/onboarding_flow_cubit.dart';
import 'package:rtu_mirea_app/onboarding/widgets/teacher_step.dart';
import 'package:rtu_mirea_app/onboarding/widgets/widgets.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/selected_schedule.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({
    this.permissionClient = const PermissionClient(),
    super.key,
  });

  final PermissionClient permissionClient;

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late final OnboardingFlowCubit _flow;

  @override
  void initState() {
    super.initState();
    _flow = OnboardingFlowCubit(
      repository: context.read<GamificationRepository>(),
      organizationId: context.read<UniversityConfig>().organizationId,
      currentUserId: () => context.read<AppBloc?>()?.state.user.id,
      isGuest: () => context.read<AppBloc?>()?.state.user.isGuest ?? false,
      selectedGroup: () =>
          switch (context.read<ScheduleBloc?>()?.state.selectedSchedule) {
            SelectedGroupSchedule(:final group) => group,
            _ => null,
          },
      persona: context.read<AccountPersonaCubit?>(),
    );
    unawaited(_preload());
  }

  @override
  void dispose() {
    unawaited(_flow.close());
    super.dispose();
  }

  Future<void> _preload() async {
    final resume = await _flow.restore(
      onboardingShown:
          context.read<HomeCubit?>()?.state.settings.onboardingShown ?? false,
    );
    if (!mounted || !_flow.ownsSession) return;
    final state = _flow.state;
    final schedule = context.read<ScheduleBloc?>();
    if (state.group case final group?
        when state.groupOrigin == OnboardingDraftOrigin.restored &&
            !state.isTeacher) {
      if (schedule != null && schedule.state.selectedSchedule == null) {
        schedule.add(ScheduleRequested(group: group));
      }
    }
    if (resume) {
      context.read<HomeCubit>().closeOnboarding();
      context.go(state.isTeacher ? '/profile/teacher' : '/feed');
    }
  }

  Future<bool> _prepareFinish() async {
    final saved = await _flow.prepareFinish();
    if (!mounted || !_flow.ownsSession) return false;
    if (!saved && _flow.state.submission.isFailure) {
      ToastManager.showError(context, message: context.l10n.identitySaveError);
    }
    return saved;
  }

  Future<void> _finish() async {
    if (!await _prepareFinish() || !mounted) return;
    final state = _flow.state;
    if (state.teacher case final teacher? when state.isTeacher) {
      context.read<ScheduleBloc>().add(
        TeacherScheduleRequested(teacher: teacher),
      );
    }
    context.read<HomeCubit>().closeOnboarding();
    if (state.group case final group? when !state.isTeacher) {
      ToastManager.showSuccess(
        context,
        message: context.l10n.onboardingWelcomeToast(group.name),
      );
    }
    context.go(state.isTeacher ? '/profile/teacher' : '/feed');
    unawaited(startAppTour(context));
  }

  Future<void> _openAccount() async {
    final app = context.read<AppBloc>();
    if (!app.state.status.isLoggedIn) {
      const AuthRoute().go(context);
      return;
    }
    final userId = app.state.user.id;
    final l10n = context.l10n;
    final confirmed = await showNinjaConfirmDialog(
      context,
      title: l10n.profileSignOutConfirm,
      message: app.state.user.isGuest ? l10n.authGuestExitWarning : null,
      confirmLabel: l10n.profileSignOut,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (confirmed && mounted && !app.isClosed && app.state.user.id == userId) {
      app.add(const AppLogoutRequested());
    }
  }

  Future<void> _createSchedule() async {
    if (!await _prepareFinish() || !mounted) return;
    context.read<HomeCubit>().closeOnboarding();
    const ScheduleCreateRoute().go(context);
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
        bloc: _flow,
        builder: (context, state) => Scaffold(
          backgroundColor: context.colors.canvas,
          body: switch (state.stage) {
            OnboardingStage.welcome => OnboardingWelcomeStep(
              key: const ValueKey('onboarding_welcome'),
              totalSteps: state.totalSteps,
              onStart: _flow.start,
              onTeacherStart: _flow.startTeacher,
              onHaveAccount: () => unawaited(_openAccount()),
            ),
            OnboardingStage.group => OnboardingGroupStep(
              key: const ValueKey('onboarding_group'),
              step: 2,
              totalSteps: state.totalSteps,
              initialQuery: state.groupQuery,
              initialSelected: state.group,
              onQueryChanged: _flow.updateGroupQuery,
              onSelected: _flow.selectGroup,
              onBack: _flow.welcome,
              onNext: _flow.afterSelection,
              onSkip: () => unawaited(_finish()),
              onCreateSchedule: () => unawaited(_createSchedule()),
            ),
            OnboardingStage.identity => OnboardingIdentityStep(
              key: const ValueKey('onboarding_identity'),
              step: 3,
              totalSteps: state.totalSteps,
              initialName:
                  state.identity.name ??
                  (state.isTeacher ? state.teacher?.name : null),
              initialHandle: state.identity.handle,
              verifiedHandle: state.identity.verifiedHandle,
              onDraftChanged: _flow.updateIdentity,
              onBack: _flow.beforeIdentity,
              onNext: _flow.completeIdentity,
            ),
            OnboardingStage.settings => OnboardingSettingsStep(
              key: const ValueKey('onboarding_settings'),
              step: state.totalSteps,
              totalSteps: state.totalSteps,
              permissionClient: widget.permissionClient,
              onBack: _flow.beforeSettings,
              onFinish: () => unawaited(_finish()),
              finishing: state.busy,
            ),
            OnboardingStage.teacher => OnboardingTeacherStep(
              key: const ValueKey('onboarding_teacher'),
              totalSteps: state.totalSteps,
              onBack: _flow.welcome,
              selected: state.teacher,
              onSelected: _flow.selectTeacher,
              onNext: _flow.afterSelection,
              onLater: _flow.teacherLater,
              onStudentMode: _flow.startStudent,
            ),
          },
        ),
      );
}
