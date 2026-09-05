import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MiniAppRefreshSurface extends StatelessWidget {
  const MiniAppRefreshSurface({
    required this.child,
    required this.refreshing,
    required this.onRetry,
    super.key,
    this.failed = false,
    this.offline = false,
  });

  final Widget child;
  final bool refreshing;
  final bool failed;
  final bool offline;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (failed || offline)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  0,
                  AppSpacing.screen,
                  AppSpacing.md,
                ),
                child: AppBanner(
                  message: offline
                      ? l10n.offlineBannerCached
                      : l10n.loadingError,
                  tone: AppBannerTone.warn,
                  actionLabel: l10n.retry,
                  onAction: refreshing ? null : onRetry,
                ),
              ),
            Expanded(key: const ValueKey('mini-app-content'), child: child),
          ],
        ),
        if (refreshing)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: LinearProgressIndicator(
                minHeight: 2,
                color: context.colors.accent,
                backgroundColor: Colors.transparent,
                semanticsLabel: l10n.loadingContent,
              ),
            ),
          ),
      ],
    );
  }
}
