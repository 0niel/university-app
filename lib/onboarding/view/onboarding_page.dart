import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_client/permission_client.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/onboarding/widgets/teacher_step.dart';
import 'package:rtu_mirea_app/onboarding/widgets/widgets.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/selected_schedule.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/tour/tour.dart';
import 'package:schedule_repository/schedule_repository.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({
    this.permissionClient = const PermissionClient(),
    super.key,
  });

  final PermissionClient permissionClient;

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

enum _Stage { welcome, group, teacher, identity, settings }

class _OnBoardingPageState extends State<OnBoardingPage> {
  _Stage _stage = _Stage.welcome;
  String? _existingName;
  String? _existingHandle;
  Group? _selectedGroup;
  Teacher? _selectedTeacher;
  var _isTeacher = false;
  var _modeEdited = false;
  var _groupQuery = '';
  var _identityRevision = 0;
  var _identityRequired = true;
  var _groupEdited = false;
  var _finishing = false;

  bool get _identityComplete =>
      (_existingName?.isNotEmpty ?? false) &&
      (_existingHandle?.isNotEmpty ?? false);

  int get _totalSteps => _identityRequired ? 4 : 3;

  @override
  void initState() {
    super.initState();
    _identityRequired =
        !(context.read<AppBloc?>()?.state.user.isGuest ?? false);
    final persona = context.read<AccountPersonaCubit?>()?.state;
    _isTeacher = persona?.isTeacher ?? false;
    _selectedTeacher = persona?.persona.teacherAvailable == true
        ? persona?.teacher
        : null;
    unawaited(_preloadIdentity());
  }

  Future<void> _preloadIdentity() async {
    final revision = _identityRevision;
    final userId = context.read<AppBloc?>()?.state.user.id;
    try {
      final repository = context.read<GamificationRepository>();
      final persona = context.read<AccountPersonaCubit?>();
      await persona?.restore();
      if (!mounted || revision != _identityRevision) return;
      final organizationId = context.read<UniversityConfig>().organizationId;
      await repository.ensureAcademicProfile(organizationId);
      final overview = await repository
          .getProfileOverview(organizationId)
          .timeout(const Duration(seconds: 8));
      if (!mounted ||
          revision != _identityRevision ||
          context.read<AppBloc?>()?.state.user.id != userId) {
        return;
      }
      setState(() {
        if (!_modeEdited && persona != null) {
          _isTeacher = persona.state.isTeacher;
          _selectedTeacher = persona.state.persona.teacherAvailable
              ? persona.state.teacher
              : null;
        }
        _existingName = overview.academic.fullName?.trim();
        _existingHandle = overview.academic.handle?.trim();
        if (!_groupEdited) {
          final savedGroup = overview.academic.group?.trim();
          final selected = context
              .read<ScheduleBloc?>()
              ?.state
              .selectedSchedule;
          _selectedGroup = switch (selected) {
            SelectedGroupSchedule(:final group)
                when savedGroup == null ||
                    savedGroup.isEmpty ||
                    group.name == savedGroup =>
              group,
            _ when savedGroup != null && savedGroup.isNotEmpty => Group(
              name: savedGroup,
            ),
            _ => null,
          };
          _groupQuery = _selectedGroup?.name ?? _groupQuery;
        }
        if (_stage == _Stage.welcome || _stage == _Stage.group) {
          _identityRequired =
              !(context.read<AppBloc?>()?.state.user.isGuest ?? false) &&
              !_identityComplete;
        }
      });
      final group = _selectedGroup;
      final schedule = context.read<ScheduleBloc?>();
      if (!_groupEdited &&
          !_isTeacher &&
          group != null &&
          schedule != null &&
          schedule.state.selectedSchedule == null) {
        schedule.add(ScheduleRequested(group: group));
      }
      if (_stage == _Stage.welcome &&
          !_groupEdited &&
          !_finishing &&
          _identityComplete &&
          (_isTeacher
              ? persona?.state.persona.teacherAvailable == true
              : (overview.academic.group?.trim().isNotEmpty ?? false)) &&
          userId != null &&
          !context.read<HomeCubit>().state.settings.onboardingShown &&
          !(context.read<AppBloc?>()?.state.user.isGuest ?? true)) {
        context.read<HomeCubit>().closeOnboarding();
        context.go(_isTeacher ? '/profile/teacher' : '/feed');
      }
    } on Exception catch (error, stackTrace) {
      log(
        'Onboarding identity preload failed',
        error: error,
        stackTrace: stackTrace,
        name: 'OnBoardingPage',
      );
    }
  }

  void _go(_Stage stage) => setState(() => _stage = stage);

  void _afterGroup() =>
      _go(_identityRequired ? _Stage.identity : _Stage.settings);

  void _beforeSettings() => _go(
    _identityRequired
        ? _Stage.identity
        : _isTeacher
        ? _Stage.teacher
        : _Stage.group,
  );

  void _completeIdentity(String name, String handle) {
    _identityRevision++;
    setState(() {
      _existingName = name;
      _existingHandle = handle;
      _stage = _Stage.settings;
    });
  }

  Future<bool> _prepareFinish() async {
    if (_finishing) return false;
    setState(() => _finishing = true);
    final userId = context.read<AppBloc?>()?.state.user.id;
    try {
      await context.read<GamificationRepository>().ensureAcademicProfile(
        context.read<UniversityConfig>().organizationId,
        academicGroup: _isTeacher ? null : _selectedGroup?.name,
      );
      if (!mounted || context.read<AppBloc?>()?.state.user.id != userId) {
        return false;
      }
      final persona = context.read<AccountPersonaCubit?>();
      if (persona != null) {
        final teacher = _selectedTeacher;
        final saved = await persona.configure(
          role: _isTeacher ? AccountRole.teacher : AccountRole.student,
          teacher: _isTeacher ? teacher : null,
          clearTeacher: _isTeacher && teacher == null,
        );
        if (!saved) {
          if (mounted) {
            ToastManager.showError(
              context,
              message: context.l10n.identitySaveError,
            );
          }
          return false;
        }
      }
      return mounted && context.read<AppBloc?>()?.state.user.id == userId;
    } on Exception catch (error, stackTrace) {
      log(
        'Onboarding profile initialization failed',
        error: error,
        stackTrace: stackTrace,
        name: 'OnBoardingPage',
      );
      if (mounted) {
        ToastManager.showError(
          context,
          message: context.l10n.identitySaveError,
        );
      }
      return false;
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }

  Future<void> _finish() async {
    if (!await _prepareFinish() || !mounted) return;
    final group = _selectedGroup;
    final teacher = _selectedTeacher;
    if (_isTeacher && teacher != null) {
      context.read<ScheduleBloc>().add(
        TeacherScheduleRequested(teacher: teacher),
      );
    }
    context.read<HomeCubit>().closeOnboarding();
    if (!_isTeacher && group != null) {
      ToastManager.showSuccess(
        context,
        message: context.l10n.onboardingWelcomeToast(group.name),
      );
    }
    context.go(_isTeacher ? '/profile/teacher' : '/feed');
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: NinjaStateSwitcher(
        duration: NinjaMotion.slow,
        child: switch (_stage) {
          _Stage.welcome => OnboardingWelcomeStep(
            key: const ValueKey('onboarding_welcome'),
            totalSteps: _totalSteps,
            onStart: () => _go(_isTeacher ? _Stage.teacher : _Stage.group),
            onTeacherStart: () {
              _modeEdited = true;
              _isTeacher = true;
              _go(_Stage.teacher);
            },
            onHaveAccount: () => unawaited(_openAccount()),
          ),
          _Stage.group => OnboardingGroupStep(
            key: const ValueKey('onboarding_group'),
            step: 2,
            totalSteps: _totalSteps,
            initialQuery: _groupQuery,
            initialSelected: _selectedGroup,
            onQueryChanged: (query) {
              _groupEdited = true;
              _groupQuery = query;
            },
            onSelected: (group) {
              _groupEdited = true;
              _selectedGroup = group;
            },
            onBack: () => _go(_Stage.welcome),
            onNext: _afterGroup,
            onSkip: () => unawaited(_finish()),
            onCreateSchedule: () => unawaited(_createSchedule()),
          ),
          _Stage.identity => OnboardingIdentityStep(
            key: const ValueKey('onboarding_identity'),
            step: 3,
            totalSteps: _totalSteps,
            initialName:
                _existingName ?? (_isTeacher ? _selectedTeacher?.name : null),
            initialHandle: _existingHandle,
            onBack: () => _go(_isTeacher ? _Stage.teacher : _Stage.group),
            onNext: _completeIdentity,
          ),
          _Stage.settings => OnboardingSettingsStep(
            key: const ValueKey('onboarding_settings'),
            step: _totalSteps,
            totalSteps: _totalSteps,
            permissionClient: widget.permissionClient,
            onBack: _beforeSettings,
            onFinish: () => unawaited(_finish()),
            finishing: _finishing,
          ),
          _Stage.teacher => OnboardingTeacherStep(
            key: const ValueKey('onboarding_teacher'),
            totalSteps: _totalSteps,
            onBack: () => _go(_Stage.welcome),
            selected: _selectedTeacher,
            onSelected: (teacher) => setState(() {
              _modeEdited = true;
              _selectedTeacher = teacher;
            }),
            onNext: _afterGroup,
            onLater: () {
              _modeEdited = true;
              _selectedTeacher = null;
              _afterGroup();
            },
            onStudentMode: () {
              _modeEdited = true;
              _isTeacher = false;
              _go(_Stage.group);
            },
          ),
        },
      ),
    );
  }
}
