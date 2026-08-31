import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Single self-hosted toast/banner/celebration presentation system.
///
/// Renders via its own [Overlay] entries (no third-party toast package).
/// Two independent slots exist: a top slot for [showBanner] and a bottom
/// slot shared by the typed toasts ([showInfo]/[showSuccess]/[showWarning]/
/// [showError]/[showLoading]) and [showCelebration]. Each slot shows at most
/// one item at a time, queues the rest (FIFO) and coalesces duplicate
/// requests (same kind + message) into the currently visible one by simply
/// extending its duration instead of stacking a new one.
class ToastManager {
  const ToastManager._();

  static final _ToastQueue _bottomQueue = _ToastQueue(alignTop: false);
  static final _ToastQueue _topQueue = _ToastQueue(alignTop: true);

  /// Clears all queued/visible toasts without animation. Intended for test
  /// isolation between `testWidgets` blocks that share this static state.
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

  /// Top-anchored push-style banner (see [AppPushNotificationBanner]).
  ///
  /// Renders in its own slot, independent from the bottom toast slot, so a
  /// banner and a regular toast can be visible at the same time.
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

  /// Bottom celebration toast (see [AppAchievementToast]). Shares the bottom
  /// slot/queue with the typed toasts above.
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

    final filled = type == ToastType.success || type == ToastType.error;
    final background = switch (type) {
      ToastType.success => colors.success,
      ToastType.error => colors.error,
      ToastType.info ||
      ToastType.warning ||
      ToastType.loading =>
        colors.surface,
    };
    final foreground = filled ? colors.white : colors.active;

    final Widget leading;
    if (emoji != null) {
      leading = Text(emoji, style: const TextStyle(fontSize: 18));
    } else {
      leading = switch (type) {
        ToastType.loading => SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
          ),
        ToastType.success => AppLineIconWidget(
            AppLineIcon.check,
            size: 18,
            color: foreground,
          ),
        ToastType.error => AppLineIconWidget(
            AppLineIcon.alert,
            size: 18,
            color: foreground,
          ),
        ToastType.warning => AppLineIconWidget(
            AppLineIcon.alert,
            size: 18,
            color: colors.warning,
          ),
        ToastType.info => AppLineIconWidget(
            AppLineIcon.check,
            size: 18,
            color: colors.primary,
          ),
      };
    }

    Widget buildToastChild(VoidCallback dismiss) => Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4D000000),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              leading,
              const SizedBox(width: AppSpacing.gap),
              Flexible(
                child: Text(
                  message,
                  style: AppText.body.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (actionLabel != null) ...[
                const SizedBox(width: AppSpacing.md),
                AppPressable(
                  onTap: () {
                    dismiss();
                    onAction?.call();
                  },
                  child: Text(
                    actionLabel,
                    style: AppText.body.copyWith(
                      color: filled ? colors.white : colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
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
  });

  final int id;
  final String coalesceKey;
  Duration duration;
  final Widget Function(VoidCallback dismiss) builder;
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

  /// Animated (slide-out) dismissal, used by the public [ToastController].
  final VoidCallback onRequestDismiss;
  final void Function(Duration duration) onRestartTimer;

  /// Immediate, non-animated removal used internally (queue advance, test
  /// reset) so it never races a ticker/animation across a torn-down tree.
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
    _overlay = Overlay.of(context, rootOverlay: true);

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
      entry.remove();
      _advance();
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
          top: alignTop ? padding.top + 8 : null,
          bottom: alignTop ? null : viewInsets.bottom + padding.bottom + 24,
          left: alignTop ? 10 : 16,
          right: alignTop ? 10 : 16,
          child: Semantics(
            liveRegion: true,
            child: _AnimatedToastSlot(
              dismissibleKey: ValueKey('toast-${queued.id}'),
              fromTop: alignTop,
              handle: handle,
              onDismiss: removeAndAdvance,
              child: Material(
                color: Colors.transparent,
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
  }

  void _advance() {
    if (_pending.isEmpty) return;
    final next = _pending.removeAt(0);
    _present(next);
  }

  @visibleForTesting
  void debugReset() {
    _pending.clear();
    _visible?.onForceRemove();
    _visible = null;
  }
}

class _AnimatedToastSlot extends StatefulWidget {
  const _AnimatedToastSlot({
    required this.child,
    required this.fromTop,
    required this.onDismiss,
    required this.handle,
    required this.dismissibleKey,
  });

  final Widget child;
  final bool fromTop;
  final VoidCallback onDismiss;
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
