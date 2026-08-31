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

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final info = await widget.repository.getSigningSecretInfo(widget.appId);
      if (mounted) setState(() => _info = info);
    } on Exception {
      if (mounted) setState(() => _info = const MiniAppSigningSecretInfo());
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
    final colors = context.ninja;
    final l10n = context.l10n;
    final info = _info;
    final hasSecret = info?.hasSecret ?? false;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Text(
          l10n.miniAppsSecretBody,
          style: NinjaText.subtext.copyWith(color: colors.muted, height: 1.5),
        ),
        const SizedBox(height: 12),
        if (_freshSecret != null) ...[
          Container(
            padding: const .all(14),
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: .circular(NinjaRadius.card),
            ),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  l10n.miniAppsSecretFresh,
                  style: NinjaText.microLabel.copyWith(
                    color: colors.mutedDark,
                  ),
                ),
                const SizedBox(height: 6),
                SelectableText(
                  _freshSecret ?? '',
                  style: NinjaText.subtext.copyWith(
                    color: colors.ink,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 10),
                NinjaButton.secondary(
                  label: l10n.miniAppsSecretCopy,
                  size: .small,
                  onPressed: () => unawaited(_copyFresh()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (info == null)
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
        const SizedBox(height: 8),
        Text(
          l10n.miniAppsSecretRotateHint,
          style: NinjaText.helper.copyWith(color: colors.muted, height: 1.4),
        ),
        const SizedBox(height: 12),
        NinjaButton.primary(
          label: hasSecret
              ? l10n.miniAppsSecretRotate
              : l10n.miniAppsSecretGenerate,
          expanded: true,
          loading: _busy,
          onPressed: _busy ? null : () => unawaited(_rotate()),
        ),
        if (hasSecret) ...[
          const SizedBox(height: 10),
          NinjaButton.destructiveOutline(
            label: l10n.miniAppsSecretDisable,
            expanded: true,
            onPressed: _busy ? null : () => unawaited(_disable()),
          ),
        ],
      ],
    );
  }
}
