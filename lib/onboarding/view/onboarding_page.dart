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
import 'package:rtu_mirea_app/onboarding/widgets/widgets.dart';
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

enum _Stage { welcome, group, identity, settings }

class _OnBoardingPageState extends State<OnBoardingPage> {
  _Stage _stage = _Stage.welcome;
  String? _existingName;
  String? _existingHandle;
  Group? _selectedGroup;
  var _groupQuery = '';
  var _identityRevision = 0;
  var _identityRequired = true;
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
    unawaited(_preloadIdentity());
  }

  Future<void> _preloadIdentity() async {
    final revision = _identityRevision;
    final userId = context.read<AppBloc?>()?.state.user.id;
    try {
      final repository = context.read<GamificationRepository>();
      final organizationId = context.read<UniversityConfig>().organizationId;
      await repository.ensureAcademicProfile(organizationId);
      final overview = await repository.getProfileOverview(organizationId);
      if (!mounted ||
          revision != _identityRevision ||
          context.read<AppBloc?>()?.state.user.id != userId) {
        return;
      }
      setState(() {
        _existingName = overview.academic.fullName?.trim();
        _existingHandle = overview.academic.handle?.trim();
        if (_stage == _Stage.welcome || _stage == _Stage.group) {
          _identityRequired =
              !(context.read<AppBloc?>()?.state.user.isGuest ?? false) &&
              !_identityComplete;
        }
      });
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

  void _beforeSettings() =>
      _go(_identityRequired ? _Stage.identity : _Stage.group);

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
        academicGroup: _selectedGroup?.name,
      );
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
    context.read<HomeCubit>().closeOnboarding();
    if (group != null) {
      ToastManager.showSuccess(
        context,
        message: context.l10n.onboardingWelcomeToast(group.name),
      );
    }
    context.go('/feed');
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
            onStart: () => _go(_Stage.group),
            onHaveAccount: () => unawaited(_openAccount()),
          ),
          _Stage.group => OnboardingGroupStep(
            key: const ValueKey('onboarding_group'),
            step: 2,
            totalSteps: _totalSteps,
            initialQuery: _groupQuery,
            initialSelected: _selectedGroup,
            onQueryChanged: (query) => _groupQuery = query,
            onSelected: (group) => _selectedGroup = group,
            onBack: () => _go(_Stage.welcome),
            onNext: _afterGroup,
            onSkip: () => unawaited(_finish()),
            onCreateSchedule: () => unawaited(_createSchedule()),
          ),
          _Stage.identity => OnboardingIdentityStep(
            key: const ValueKey('onboarding_identity'),
            step: 3,
            totalSteps: _totalSteps,
            initialName: _existingName,
            initialHandle: _existingHandle,
            onBack: () => _go(_Stage.group),
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
        },
      ),
    );
  }
}
