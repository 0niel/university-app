import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/bloc/remote_preference_sync.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CustomScheduleSyncBanner extends StatelessWidget {
  const CustomScheduleSyncBanner({
    required this.status,
    required this.onRetry,
    super.key,
  });

  final RemotePreferenceSyncStatus status;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (icon, title, subtitle, retryable) = switch (status) {
      .initializing || .syncing => (
        AppLineIcon.refresh,
        l10n.customScheduleSyncInProgress,
        l10n.customScheduleSyncInProgressSubtitle,
        false,
      ),
      .dirty => (
        AppLineIcon.clock,
        l10n.customScheduleSyncPending,
        l10n.customScheduleSyncPendingSubtitle,
        false,
      ),
      .offline => (
        AppLineIcon.wifiOff,
        l10n.customScheduleSyncOffline,
        l10n.customScheduleSyncOfflineSubtitle,
        true,
      ),
      .conflict => (
        AppLineIcon.shield,
        l10n.customScheduleSyncConflict,
        l10n.customScheduleSyncConflictSubtitle,
        true,
      ),
      .initial || .synced => (null, '', '', false),
    };
    if (title.isEmpty) return const SizedBox.shrink();
    return AppContextBanner(
      icon: icon,
      title: title,
      subtitle: subtitle,
      actionLabel: retryable ? l10n.retry : null,
      onTap: retryable ? onRetry : null,
    );
  }
}
