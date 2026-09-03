import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_secret_skeleton.dart';

class MiniAppSecretSheet extends StatefulWidget {
  const MiniAppSecretSheet({
    required this.repository,
    required this.appId,
    super.key,
  });

  final MiniAppsRepository repository;

  final String appId;

  @override
  State<MiniAppSecretSheet> createState() => _MiniAppSecretSheetState();
}

class _MiniAppSecretSheetState extends State<MiniAppSecretSheet> {
  MiniAppSigningSecretInfo? _info;
  String? _freshSecret;
  bool _busy = false;
  bool _loadFailed = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() {
      _loadFailed = false;
      _loading = true;
    });
    try {
      final info = await widget.repository.getSigningSecretInfo(widget.appId);
      if (mounted) setState(() => _info = info);
    } on Exception {
      if (mounted) setState(() => _loadFailed = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _rotate() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final created = await widget.repository.rotateSigningSecret(widget.appId);
      if (!mounted) return;
      setState(() => _freshSecret = created.secret);
      await _load();
    } on Exception {
      if (mounted) {
        showNinjaToast(
          context,
          showCheck: false,
          message: context.l10n.miniAppsSecretFailure,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _disable() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.repository.revokeSigningSecret(widget.appId);
      if (mounted) setState(() => _freshSecret = null);
      await _load();
    } on Exception {
      if (mounted) {
        showNinjaToast(
          context,
          showCheck: false,
          message: context.l10n.miniAppsSecretFailure,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _copyFresh() async {
    final secret = _freshSecret;
    if (secret == null) return;
    await Clipboard.setData(ClipboardData(text: secret));
    if (!mounted) return;
    showNinjaToast(context, message: context.l10n.miniAppsSecretCopied);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final info = _info;
    final hasSecret = info?.hasSecret ?? false;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Text(
          l10n.miniAppsSecretBody,
          style: AppText.subtext.copyWith(color: colors.muted, height: 1.5),
        ),
        const SizedBox(height: AppSpacing.md),
        if (_freshSecret != null) ...[
          Container(
            padding: const .all(14),
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: .circular(AppRadius.card),
            ),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  l10n.miniAppsSecretFresh,
                  style: AppText.captionSmall.copyWith(
                    color: colors.muted,
                  ),
                ),
                const SizedBox(height: 6),
                SelectableText(
                  _freshSecret ?? '',
                  style: AppText.subtext.copyWith(
                    color: colors.ink,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: AppSpacing.gap),
                NinjaButton.secondary(
                  label: l10n.miniAppsSecretCopy,
                  size: .small,
                  onPressed: () => unawaited(_copyFresh()),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (_loadFailed)
          NinjaErrorState(
            title: l10n.loadingError,
            retryLabel: l10n.retry,
            onRetry: () => unawaited(_load()),
          )
        else if (info == null || _loading)
          const MiniAppSecretSkeleton()
        else
          NinjaListCell(
            title: hasSecret
                ? l10n.miniAppsSecretActive(info.fingerprint ?? '······')
                : l10n.miniAppsSecretNone,
            subtitle: info.previousActive
                ? l10n.miniAppsSecretPrevActive
                : null,
            horizontalPadding: 0,
            showChevron: false,
          ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.miniAppsSecretRotateHint,
          style: AppText.captionSmall.copyWith(
            color: colors.muted,
            height: 1.4,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        NinjaButton.primary(
          label: hasSecret
              ? l10n.miniAppsSecretRotate
              : l10n.miniAppsSecretGenerate,
          expanded: true,
          loading: _busy,
          onPressed: _busy || _loading || info == null || _loadFailed
              ? null
              : () => unawaited(_rotate()),
        ),
        if (hasSecret) ...[
          const SizedBox(height: AppSpacing.gap),
          NinjaButton.destructiveOutline(
            label: l10n.miniAppsSecretDisable,
            expanded: true,
            onPressed: _busy || _loading || _loadFailed
                ? null
                : () => unawaited(_disable()),
          ),
        ],
      ],
    );
  }
}
