import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_icon_tile.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_toast.dart';
import 'package:app_ui/src/widgets/profile/app_achievement_toast.dart';
import 'package:app_ui/src/widgets/profile/app_push_notification_banner.dart';
import 'package:app_ui/src/widgets/toast/toast_controller.dart';
import 'package:app_ui/src/widgets/toast/toast_type.dart';
import 'package:flutter/material.dart';

class ToastManager {
  const ToastManager._();

  static final _ToastQueue _bottomQueue = _ToastQueue(alignTop: false);
  static final _ToastQueue _topQueue = _ToastQueue(alignTop: true);

  @visibleForTesting
  static void debugReset() {
    _bottomQueue.debugReset();
    _topQueue.debugReset();
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    String? emoji,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(milliseconds: 2200),
  }) {
    _show(
      context,
      message: message,
      type: ToastType.info,
      emoji: emoji,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    String? emoji,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(milliseconds: 2200),
  }) {
    _show(
      context,
      message: message,
      type: ToastType.success,
      emoji: emoji,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    String? emoji,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(milliseconds: 2600),
  }) {
    _show(
      context,
      message: message,
      type: ToastType.warning,
      emoji: emoji,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    String? emoji,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(milliseconds: 3000),
  }) {
    _show(
      context,
      message: message,
      type: ToastType.error,
      emoji: emoji,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static ToastController showLoading(BuildContext context, {String? message}) {
    return _show(
      context,
      message: message ?? 'Загрузка...',
      type: ToastType.loading,
      duration: const Duration(days: 365),
    );
  }

  static Future<T> runAsync<T>(
    BuildContext context, {
    required Future<T> Function() task,
    String? loadingMessage,
    String? successMessage,
    String? errorMessage,
  }) async {
    final loading = showLoading(context, message: loadingMessage);
    try {
      final result = await task();
      loading.dismiss();
      if (context.mounted) {
        showSuccess(context, message: successMessage ?? 'Готово');
      }
      return result;
    } on Exception catch (e, st) {
      log(
        'runAsync task failed',
        error: e,
        stackTrace: st,
        name: 'ToastManager',
      );
      loading.dismiss();
      if (context.mounted) {
        showError(context, message: errorMessage ?? 'Ошибка');
      }
      rethrow;
    }
  }

  static ToastController showBanner(
    BuildContext context, {
    required String title,
    required String message,
    String? timeLabel,
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 4),
  }) {
    return _topQueue.show(
      context,
      coalesceKey: 'banner|$title|$message',
      duration: duration,
      builder: (dismiss) => AppPushNotificationBanner(
        title: title,
        message: message,
        timeLabel: timeLabel ?? 'сейчас',
        onTap: () {
          dismiss();
          onTap?.call();
        },
      ),
    );
  }

  static ToastController showCelebration(
    BuildContext context, {
    required String emoji,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 4),
  }) {
    return _bottomQueue.show(
      context,
      coalesceKey: 'celebration|$title|$subtitle',
      duration: duration,
      builder: (dismiss) => AppAchievementToast(
        emoji: emoji,
        title: title,
        subtitle: subtitle,
        onTap: () {
          dismiss();
          onTap?.call();
        },
      ),
    );
  }

  static ToastController _show(
    BuildContext context, {
    required String message,
    required ToastType type,
    String? emoji,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(milliseconds: 2000),
  }) {
    final colors = Theme.of(context).colors;
    final tone = switch (type) {
      ToastType.success => colors.lecture,
      ToastType.error => colors.exam,
      ToastType.warning => colors.warn,
      ToastType.info || ToastType.loading => colors.accent,
    };
    final icon = switch (type) {
      ToastType.success => AppLineIcon.check,
      ToastType.error || ToastType.warning => AppLineIcon.alert,
      ToastType.info => AppLineIcon.info,
      ToastType.loading => AppLineIcon.refresh,
    };

    Widget buildToastChild(VoidCallback dismiss) => AppToast(
          message: message,
          icon: icon,
          iconColor: tone,
          actionLabel: actionLabel,
          onAction: onAction == null
              ? null
              : () {
                  dismiss();
                  onAction.call();
                },
          leading: emoji == null
              ? null
              : AppIconTile(
                  size: 32,
                  radius: AppRadius.sm,
                  background: colors.surface2,
                  child: Text(emoji, style: AppText.sans(17, FontWeight.w400)),
                ),
        );

    return _bottomQueue.show(
      context,
      coalesceKey: '${type.name}|$message',
      duration: duration,
      builder: buildToastChild,
    );
  }
}

class _ToastIds {
  const _ToastIds._();

  static int _next = 0;

  static int next() => _next++;
}

class _QueuedToast {
  _QueuedToast({
    required this.id,
    required this.coalesceKey,
    required this.duration,
    required this.builder,
    required this.bottomInset,
  });

  final int id;
  final String coalesceKey;
  Duration duration;
  final Widget Function(VoidCallback dismiss) builder;
  final double bottomInset;
}

class _VisibleToast {
  const _VisibleToast({
    required this.id,
    required this.coalesceKey,
    required this.onRequestDismiss,
    required this.onRestartTimer,
    required this.onForceRemove,
  });

  final int id;
  final String coalesceKey;
  final VoidCallback onRequestDismiss;
  final void Function(Duration duration) onRestartTimer;
  final VoidCallback onForceRemove;
}

class _ToastAnimationHandle {
  VoidCallback? onExit;
  VoidCallback? onFallbackExit;

  void exit() {
    final handler = onExit ?? onFallbackExit;
    handler?.call();
  }
}

class _ToastQueue {
  _ToastQueue({required this.alignTop});

  final bool alignTop;
  final List<_QueuedToast> _pending = [];
  _VisibleToast? _visible;
  OverlayState? _overlay;

  ToastController show(
    BuildContext context, {
    required String coalesceKey,
    required Duration duration,
    required Widget Function(VoidCallback dismiss) builder,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    if (_overlay != null && !identical(_overlay, overlay)) {
      _clear();
    }
    _overlay = overlay;

    final visible = _visible;
    if (visible != null && visible.coalesceKey == coalesceKey) {
      visible.onRestartTimer(duration);
      return ToastController(visible.onRequestDismiss);
    }

    final queued = _QueuedToast(
      id: _ToastIds.next(),
      coalesceKey: coalesceKey,
      duration: duration,
      builder: builder,
      bottomInset: math.max(
        MediaQuery.paddingOf(context).bottom,
        MediaQuery.viewPaddingOf(context).bottom,
      ),
    );

    if (_visible == null) {
      _present(queued);
    } else {
      _pending.add(queued);
    }

    return ToastController(() {
      if (_visible?.id == queued.id) {
        _visible?.onRequestDismiss();
      } else {
        _pending.removeWhere((q) => q.id == queued.id);
      }
    });
  }

  void _present(_QueuedToast queued) {
    final overlay = _overlay;
    if (overlay == null) return;

    final handle = _ToastAnimationHandle();
    Timer? timer;
    var handled = false;
    late final OverlayEntry entry;

    void removeAndAdvance() {
      if (handled) return;
      handled = true;
      timer?.cancel();
      if (_visible?.id == queued.id) {
        _visible = null;
      }
      entry
        ..remove()
        ..dispose();
      _advance();
    }

    void discardOnDispose() {
      if (handled) return;
      handled = true;
      timer?.cancel();
      if (_visible?.id == queued.id) {
        _visible = null;
        _pending.clear();
        if (identical(_overlay, overlay)) _overlay = null;
      }
      scheduleMicrotask(() {
        entry
          ..remove()
          ..dispose();
      });
    }

    void scheduleTimer(Duration duration) {
      timer?.cancel();
      timer = Timer(duration, handle.exit);
    }

    handle.onFallbackExit = removeAndAdvance;

    entry = OverlayEntry(
      builder: (entryContext) {
        final padding = MediaQuery.paddingOf(entryContext);
        final viewInsets = MediaQuery.viewInsetsOf(entryContext);
        return Positioned(
          top: alignTop ? padding.top + AppSpacing.sm : null,
          bottom: alignTop
              ? null
              : math.max(
                    viewInsets.bottom,
                    math.max(padding.bottom, queued.bottomInset),
                  ) +
                  AppSpacing.xlg,
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          child: Semantics(
            liveRegion: true,
            child: _AnimatedToastSlot(
              dismissibleKey: ValueKey('toast-${queued.id}'),
              fromTop: alignTop,
              handle: handle,
              onDismiss: removeAndAdvance,
              onDispose: discardOnDispose,
              child: Material(
                color: const Color(0x00000000),
                child: queued.builder(handle.exit),
              ),
            ),
          ),
        );
      },
    );
    _visible = _VisibleToast(
      id: queued.id,
      coalesceKey: queued.coalesceKey,
      onRequestDismiss: handle.exit,
      onForceRemove: removeAndAdvance,
      onRestartTimer: scheduleTimer,
    );

    overlay.insert(entry);
    scheduleTimer(queued.duration);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!overlay.mounted) discardOnDispose();
    });
  }

  void _advance() {
    if (_pending.isEmpty) return;
    final next = _pending.removeAt(0);
    _present(next);
  }

  @visibleForTesting
  void debugReset() => _clear();

  void _clear() {
    _pending.clear();
    _visible?.onForceRemove();
    _visible = null;
    _overlay = null;
  }
}

class _AnimatedToastSlot extends StatefulWidget {
  const _AnimatedToastSlot({
    required this.child,
    required this.fromTop,
    required this.onDismiss,
    required this.onDispose,
    required this.handle,
    required this.dismissibleKey,
  });

  final Widget child;
  final bool fromTop;
  final VoidCallback onDismiss;
  final VoidCallback onDispose;
  final _ToastAnimationHandle handle;
  final Key dismissibleKey;

  @override
  State<_AnimatedToastSlot> createState() => _AnimatedToastSlotState();
}

class _AnimatedToastSlotState extends State<_AnimatedToastSlot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );
  var _dismissed = false;

  @override
  void initState() {
    super.initState();
    widget.handle.onExit = _animateOutAndRemove;
    unawaited(_controller.forward());
  }

  @override
  void dispose() {
    widget.handle.onExit = null;
    _controller.dispose();
    widget.onDispose();
    super.dispose();
  }

  Future<void> _animateOutAndRemove() async {
    if (_dismissed) return;
    _dismissed = true;
    if (mounted) {
      final reduceMotion = MediaQuery.disableAnimationsOf(context);
      if (!reduceMotion) {
        await _controller.reverse();
      }
    }
    widget.onDismiss();
  }

  void _handleSwiped() {
    if (_dismissed) return;
    _dismissed = true;
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    var content = widget.child;
    if (reduceMotion) {
      content = FadeTransition(opacity: _controller, child: content);
    } else {
      final offset = Tween(
        begin: Offset(0, widget.fromTop ? -1 : 1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      content = SlideTransition(position: offset, child: content);
    }

    return Dismissible(
      key: widget.dismissibleKey,
      direction: widget.fromTop ? DismissDirection.up : DismissDirection.down,
      onDismissed: (_) => _handleSwiped(),
      child: content,
    );
  }
}
