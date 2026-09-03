import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_tokens_skeleton.dart';

class MiniAppTokensSheet extends StatefulWidget {
  const MiniAppTokensSheet({required this.repository, super.key});

  final MiniAppsRepository repository;

  @override
  State<MiniAppTokensSheet> createState() => _MiniAppTokensSheetState();
}

class _MiniAppTokensSheetState extends State<MiniAppTokensSheet> {
  List<MiniAppDeployToken>? _tokens;
  String? _freshToken;
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
      final tokens = await widget.repository.listDeployTokens();
      if (mounted) setState(() => _tokens = tokens);
    } on Exception {
      if (mounted) setState(() => _loadFailed = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _create() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final created = await widget.repository.createDeployToken(
        name: 'token-${(_tokens?.length ?? 0) + 1}',
      );
      if (!mounted) return;
      setState(() => _freshToken = created.token);
      await _load();
    } on Exception {
      if (mounted) {
        showNinjaToast(
          context,
          showCheck: false,
          message: context.l10n.miniAppsTokensFailure,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _revoke(MiniAppDeployToken token) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.repository.revokeDeployToken(token.id);
      await _load();
    } on Exception {
      if (mounted) {
        showNinjaToast(
          context,
          showCheck: false,
          message: context.l10n.miniAppsTokensFailure,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _copyFresh() async {
    final token = _freshToken;
    if (token == null) return;
    await Clipboard.setData(ClipboardData(text: token));
    if (!mounted) return;
    showNinjaToast(context, message: context.l10n.miniAppsTokensCopied);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final tokens = _tokens;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Text(
          l10n.miniAppsTokensBody,
          style: AppText.subtext.copyWith(color: colors.muted, height: 1.5),
        ),
        const SizedBox(height: AppSpacing.md),
        if (_freshToken != null) ...[
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
                  l10n.miniAppsTokensFresh,
                  style: AppText.captionSmall.copyWith(
                    color: colors.muted,
                  ),
                ),
                const SizedBox(height: 6),
                SelectableText(
                  _freshToken ?? '',
                  style: AppText.subtext.copyWith(
                    color: colors.ink,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: AppSpacing.gap),
                NinjaButton.secondary(
                  label: l10n.miniAppsTokensCopy,
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
        else if (tokens == null || _loading)
          const MiniAppTokensSkeleton()
        else
          for (final token in tokens)
            NinjaListCell(
              title: token.name.isEmpty ? token.id : token.name,
              subtitle: token.lastUsedAt == null
                  ? l10n.miniAppsTokensNeverUsed
                  : l10n.miniAppsTokensUsed,
              horizontalPadding: 0,
              showChevron: false,
              trailing: NinjaIconButton(
                icon: const AppLineIconWidget(.close, size: AppIconSize.md),
                tooltip: l10n.miniAppsTokensRevoke,
                onPressed: _busy ? null : () => unawaited(_revoke(token)),
              ),
            ),
        const SizedBox(height: AppSpacing.md),
        NinjaButton.primary(
          label: l10n.miniAppsTokensCreate,
          expanded: true,
          loading: _busy,
          onPressed: _busy || _loading || tokens == null || _loadFailed
              ? null
              : () => unawaited(_create()),
        ),
      ],
    );
  }
}
