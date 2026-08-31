import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:permission_client/permission_client.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:rtu_mirea_app/tour/tour.dart';
import 'package:schedule_repository/schedule_repository.dart';

part '../widgets/welcome_step.dart';
part '../widgets/welcome_hero_card.dart';
part '../widgets/onboard_step.dart';
part '../widgets/onboard_header.dart';
part '../widgets/onboard_circle_button.dart';
part '../widgets/onboarding_lead_icon.dart';
part '../widgets/step_pills.dart';
part '../widgets/group_step.dart';
part '../widgets/group_step_body.dart';
part '../widgets/group_search_field.dart';
part '../widgets/group_result_row.dart';
part '../widgets/group_results_skeleton.dart';
part '../widgets/group_result_row_skeleton.dart';
part '../widgets/handle_check.dart';
part '../widgets/identity_step.dart';
part '../widgets/identity_body.dart';
part '../widgets/permissions_step.dart';
part '../widgets/permissions_step_body.dart';
part '../widgets/permission_rows_skeleton.dart';
part '../widgets/permission_row.dart';
part '../widgets/granted_check.dart';
part '../widgets/shuriken_mark.dart';
part '../widgets/ninja_hero.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({
    this.permissionClient = const PermissionClient(),
    super.key,
  });

  final PermissionClient permissionClient;

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

enum _OnboardingStage { welcome, group, identity, permissions }

class _OnBoardingPageState extends State<OnBoardingPage>
    with SingleTickerProviderStateMixin {
  static const double _zeroTurns = 0;
  static const double _fullTurn = 1;

  late final AnimationController _spinController;
  late final Animation<double> _shurikenTurns;

  late _OnboardingStage _stage;

  String? _existingName;
  String? _existingHandle;
  Group? _selectedGroup;
  var _groupQuery = '';
  var _motionEnabled = false;
  var _identityRevision = 0;

  bool get _identityComplete =>
      (_existingName?.isNotEmpty ?? false) &&
      (_existingHandle?.isNotEmpty ?? false);

  @override
  void initState() {
    super.initState();
    _stage = .welcome;
    unawaited(_preloadIdentity());
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _shurikenTurns = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: _zeroTurns,
          end: 0.5,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(tween: ConstantTween(0.5), weight: 10),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.5,
          end: _fullTurn,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(tween: ConstantTween(1), weight: 10),
    ]).animate(_spinController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final shouldAnimate =
        !MediaQuery.disableAnimationsOf(context) &&
        !MediaQuery.accessibleNavigationOf(context);
    if (_motionEnabled == shouldAnimate) return;
    _motionEnabled = shouldAnimate;
    if (shouldAnimate) {
      unawaited(_spinController.repeat());
    } else {
      _spinController
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  Future<void> _preloadIdentity() async {
    final revision = _identityRevision;
    try {
      final overview = await context
          .read<GamificationRepository>()
          .getProfileOverview(
            context.read<UniversityConfig>().organizationId,
          );
      if (!mounted || revision != _identityRevision) return;
      setState(() {
        _existingName = overview.academic.fullName?.trim();
        _existingHandle = overview.academic.handle?.trim();
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

  void _goToGroupStep() => setState(() => _stage = .group);

  void _backToWelcome() => setState(() => _stage = .welcome);

  void _goToIdentity() => setState(
    () => _stage = _identityComplete ? .permissions : .identity,
  );

  void _backToGroup() => setState(() => _stage = .group);

  void _completeIdentity(String name, String handle) {
    _identityRevision++;
    setState(() {
      _existingName = name;
      _existingHandle = handle;
      _stage = .permissions;
    });
  }

  void _backToIdentity() => setState(
    () => _stage = _identityComplete ? .group : .identity,
  );

  void _finish() {
    context.read<HomeCubit>().closeOnboarding();
    context.go('/feed');
    unawaited(startAppTour(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.ninja.canvas,
      body: SafeArea(
        child: NinjaStateSwitcher(
          duration: NinjaMotion.slow,
          child: switch (_stage) {
            .welcome => _WelcomeStep(
              key: const ValueKey('onboarding_welcome'),
              config: context.read(),
              shurikenTurns: _shurikenTurns,
              onContinue: _goToGroupStep,
              onGuest: _finish,
            ),
            .group => _GroupStep(
              key: const ValueKey('onboarding_group'),
              initialQuery: _groupQuery,
              initialSelected: _selectedGroup,
              onQueryChanged: (query) => _groupQuery = query,
              onSelected: (group) => _selectedGroup = group,
              onBack: _backToWelcome,
              onNext: _goToIdentity,
            ),
            .identity => _IdentityStep(
              key: const ValueKey('onboarding_identity'),
              initialName: _existingName,
              initialHandle: _existingHandle,
              onBack: _backToGroup,
              onNext: _completeIdentity,
            ),
            .permissions => _PermissionsStep(
              key: const ValueKey('onboarding_permissions'),
              permissionClient: widget.permissionClient,
              onBack: _backToIdentity,
              onFinish: _finish,
            ),
          },
        ),
      ),
    );
  }
}
