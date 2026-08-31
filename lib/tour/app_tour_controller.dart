import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/tour/app_tour_anchors.dart';
import 'package:rtu_mirea_app/tour/model/app_tour_step.dart';
import 'package:rtu_mirea_app/tour/model/app_tour_target.dart';

class AppTourController extends ChangeNotifier {
  AppTourController({this.anchorTimeout = const Duration(seconds: 3)});

  static final AppTourController instance = AppTourController();

  static const Duration _pollInterval = Duration(milliseconds: 32);
  static const Duration _settle = Duration(milliseconds: 90);

  final Duration anchorTimeout;

  GoRouter? _router;
  List<AppTourStep> _steps = const [];
  int _index = 0;
  bool _active = false;
  bool _moving = false;
  Rect? _hole;
  int _run = 0;

  bool get isActive => _active;

  bool get isMoving => _moving;

  int get index => _index;
  int get length => _steps.length;
  Rect? get hole => _hole;
  bool get isFirst => _index == 0;
  bool get isLast => _index >= _steps.length - 1;

  AppTourStep? get step => _active ? _steps.elementAtOrNull(_index) : null;

  GoRouter? get router => _router;

  set router(GoRouter value) => _router = value;

  Future<void> start(List<AppTourStep> steps) async {
    if (steps.isEmpty) return;
    _run++;
    _steps = steps;
    _index = 0;
    _active = true;
    _moving = false;
    _hole = null;
    notifyListeners();
    await _show(targetIndex: 0, forward: true);
  }

  Future<void> next() async {
    if (!_active || _moving) return;
    if (isLast) {
      stop();
      return;
    }
    await _show(targetIndex: _index + 1, forward: true);
  }

  Future<void> back() async {
    if (!_active || _moving || isFirst) return;
    await _show(targetIndex: _index - 1, forward: false);
  }

  void stop() {
    if (!_active) return;
    _run++;
    _active = false;
    _moving = false;
    _steps = const [];
    _index = 0;
    _hole = null;
    notifyListeners();
  }

  void syncHole(Rect? rect) {
    if (_moving || rect == _hole) return;
    _hole = rect;
    notifyListeners();
  }

  Future<void> _show({required int targetIndex, required bool forward}) async {
    final run = ++_run;
    _moving = true;
    notifyListeners();
    var candidateIndex = targetIndex;
    AppTourStep? candidateStep;
    BuildContext? anchor;

    while (candidateStep == null &&
        candidateIndex >= 0 &&
        candidateIndex < _steps.length) {
      final currentStep = _steps.elementAtOrNull(candidateIndex);
      if (currentStep == null) {
        candidateIndex += forward ? 1 : -1;
        continue;
      }
      _openLocation(currentStep.location);

      final target = currentStep.target;
      final currentAnchor = target == null
          ? null
          : await _awaitAnchor(target, run);
      if (run != _run || !_active) return;

      if (target != null && currentAnchor == null && currentStep.optional) {
        candidateIndex += forward ? 1 : -1;
        continue;
      }

      candidateStep = currentStep;
      anchor = currentAnchor;
    }

    if (candidateStep == null) {
      stop();
      return;
    }

    if (anchor != null && anchor.mounted) {
      await _ensureVisible(anchor);
      if (run != _run || !_active) return;
    }

    _index = candidateIndex;
    final target = candidateStep.target;
    _hole = target == null ? null : AppTourAnchors.rectOf(target);
    _moving = false;
    notifyListeners();
  }

  void _openLocation(String? location) {
    final activeRouter = _router;
    if (location == null || activeRouter == null) return;
    if (_currentLocation(activeRouter) == location) return;
    activeRouter.go(location);
  }

  String? _currentLocation(GoRouter activeRouter) {
    try {
      return activeRouter.state.uri.path;
    } on Object catch (_) {
      return null;
    }
  }

  Future<BuildContext?> _awaitAnchor(AppTourTarget target, int run) async {
    final attempts =
        anchorTimeout.inMilliseconds ~/ _pollInterval.inMilliseconds;
    for (var attempt = 0; attempt < attempts; attempt++) {
      await Future<void>.delayed(_pollInterval);
      if (run != _run || !_active) return null;
      final context = AppTourAnchors.contextOf(target);
      if (context != null) return context;
    }
    return null;
  }

  Future<void> _ensureVisible(BuildContext context) async {
    if (!context.mounted) return;
    if (Scrollable.maybeOf(context) == null) return;
    final media = MediaQuery.maybeOf(context);
    final reduceMotion =
        (media?.disableAnimations ?? false) ||
        (media?.accessibleNavigation ?? false);
    try {
      await Scrollable.ensureVisible(
        context,
        alignment: 0.4,
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } on Object catch (_) {
      return;
    }
    await Future<void>.delayed(_settle);
  }
}
