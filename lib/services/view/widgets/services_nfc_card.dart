import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_hce_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/pass_security_cubit.dart';

class ServicesNfcCard extends StatefulWidget {
  const ServicesNfcCard({super.key, this.activeWindow = defaultActiveWindow});

  static const defaultActiveWindow = Duration(seconds: 30);

  final Duration activeWindow;

  @override
  State<ServicesNfcCard> createState() => _ServicesNfcCardState();
}

class _ServicesNfcCardState extends State<ServicesNfcCard>
    with WidgetsBindingObserver {
  Timer? _timer;
  late final NfcPassCubit _pass;
  bool _active = false;
  bool _activating = false;
  int _activation = 0;

  @override
  void initState() {
    super.initState();
    _pass = context.read<NfcPassCubit>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _deactivate();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _activation++;
    WidgetsBinding.instance.removeObserver(this);
    if (_active) {
      unawaited(_release());
    }
    super.dispose();
  }

  Future<void> _activate() async {
    if (_activating) return;
    final revision = ++_activation;
    setState(() => _activating = true);
    try {
      final authenticated = await context
          .read<PassSecurityCubit>()
          .authenticateForPass(reason: context.l10n.passLockReason);
      if (!mounted || revision != _activation || !authenticated) return;
      final hce = context.read<NfcHceCubit>().state;
      if (_pass.state.status != NfcPassStatus.bound ||
          !hce.available ||
          !hce.enabled) {
        return;
      }
      await _pass.claimTurnstilePriority();
      if (!mounted || revision != _activation) {
        await _release();
        return;
      }
      setState(() => _active = true);
      _timer?.cancel();
      _timer = Timer(widget.activeWindow, _deactivate);
    } on Object {
      if (mounted) {
        ToastManager.showError(
          context,
          message: context.l10n.nfcPassErrorDescription,
        );
      }
    } finally {
      if (mounted) setState(() => _activating = false);
    }
  }

  Future<void> _release() async {
    try {
      await _pass.releaseTurnstilePriority();
    } on Object {
      if (mounted) {
        ToastManager.showError(
          context,
          message: context.l10n.nfcPassErrorDescription,
        );
      }
    }
  }

  void _deactivate() {
    if (!_active && !_activating) return;
    _timer?.cancel();
    _activation++;
    _timer = null;
    if (!mounted) return;
    setState(() => _active = false);
    unawaited(_release());
  }

  void _onTap(bool ready) {
    if (_active) {
      _deactivate();
    } else if (ready) {
      unawaited(_activate());
    } else {
      context.go('/services/nfc');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final pass = context.watch<NfcPassCubit>().state;
    final hce = context.watch<NfcHceCubit>().state;
    final bound = pass.status == NfcPassStatus.bound;
    final ready = bound && hce.available && hce.enabled;
    if (_active && !ready) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _active) _deactivate();
      });
    }

    final title = _active
        ? l10n.servicesNfcActiveTitle
        : l10n.servicesNfcOpenTitle;
    final subtitle = _active
        ? l10n.servicesNfcActiveSub
        : !bound
        ? l10n.servicesNfcConnectSub
        : hce.loaded && !hce.available
        ? l10n.servicesNfcUnavailableSub
        : hce.loaded && !hce.enabled
        ? l10n.settingsNfcEmulationSub
        : l10n.servicesNfcPassSub(_maskedPassId(pass.passId));

    final bg = _active ? colors.accent : colors.tint;
    final fg = _active ? colors.onAccent : colors.ink;
    final iconBg = _active
        ? colors.white.withValues(alpha: .22)
        : colors.surface;

    return AppPressable(
      key: const ValueKey('services-nfc-card'),
      onTap: _activating ? null : () => _onTap(ready),
      pressedScale: 1,
      semanticsLabel: '$title, $subtitle',
      semanticsButton: true,
      child: AnimatedContainer(
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sectionGap,
          AppSpacing.md,
          AppSpacing.sectionGap,
          AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 250),
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: AppLineIconWidget(
                AppLineIcon.contactless,
                size: AppIconSize.md,
                color: fg,
                strokeWidth: 2.2,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.headlineStrong.copyWith(color: fg),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption.copyWith(
                      color: fg.withValues(alpha: .7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: AppIconSize.sm,
              color: fg.withValues(alpha: .6),
            ),
          ],
        ),
      ),
    );
  }
}

String _maskedPassId(int? id) {
  final value = id?.toString() ?? '—';
  if (value.length <= 4) return value;
  return '${value.substring(0, 2)} ••• ${value.substring(value.length - 2)}';
}
