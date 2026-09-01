import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_client/local_auth_client.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_hce_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/pass_security_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/device_label.dart';
import 'package:rtu_mirea_app/nfc_pass/view/nfc_pass_view.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/widgets.dart';

part 'pass_lock_screen.dart';

class NfcPassPage extends StatefulWidget {
  const NfcPassPage({super.key});

  @override
  State<NfcPassPage> createState() => _NfcPassPageState();
}

class _NfcPassPageState extends State<NfcPassPage> {
  late final NfcPassCubit _nfcPassCubit;
  late final String _deviceName;

  bool _unlocked = true;
  bool _authInFlight = false;

  @override
  void initState() {
    super.initState();
    _deviceName = deviceLabelFor(defaultTargetPlatform);
    _nfcPassCubit = context.read<NfcPassCubit>();
    unawaited(_nfcPassCubit.checkBound());
    final security = context.read<PassSecurityCubit>();
    if (security.state.enabled) {
      _unlocked = false;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => unawaited(_initSecurity()),
      );
    }
  }

  @override
  void dispose() {
    unawaited(_nfcPassCubit.releaseTurnstilePriority());
    super.dispose();
  }

  Future<void> _initSecurity() async {
    final security = context.read<PassSecurityCubit>();
    await security.refreshCapability();
    if (!mounted) return;
    if (security.state.isActive) {
      await _promptUnlock();
    } else {
      setState(() => _unlocked = true);
      unawaited(_claimIfBound());
    }
  }

  Future<void> _promptUnlock() async {
    if (_authInFlight) return;
    setState(() => _authInFlight = true);
    final unlocked = await context
        .read<PassSecurityCubit>()
        .authenticateForPass(
          reason: context.l10n.passLockReason,
        );
    if (!mounted) return;
    setState(() {
      _unlocked = unlocked;
      _authInFlight = false;
    });
    if (unlocked) unawaited(_claimIfBound());
  }

  Future<void> _claimIfBound() async {
    final cubit = context.read<NfcPassCubit>();
    if (cubit.state.status == .bound) {
      await cubit.claimTurnstilePriority();
    }
  }

  void _openSettings() {
    unawaited(
      showAppSheet<void>(
        context,
        title: context.l10n.settingsNfcTitle,
        child: const NfcCardSettingsSheet(),
      ),
    );
  }

  void _showCodeSheet() {
    final cubit = context.read<NfcPassCubit>();
    unawaited(
      showAppSheet<void>(
        context,
        title: context.l10n.nfcPassCodeSheetTitle,
        subtitle: context.l10n.nfcPassCodeSheetDescription,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: NinjaCodeInput(
            autofocus: true,
            onCompleted: (code) {
              unawaited(
                cubit.confirmBinding(
                  sixDigitCode: code,
                  deviceName: _deviceName,
                ),
              );
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ),
      ),
    );
  }

  Future<void> _confirmUnbind() async {
    final l10n = context.l10n;
    final cubit = context.read<NfcPassCubit>();
    final confirmed = await showNinjaConfirmDialog(
      context,
      title: l10n.nfcPassUnbindConfirmTitle,
      message: l10n.nfcPassUnbindConfirmDescription,
      confirmLabel: l10n.nfcPassUnbindButton,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (!confirmed) return;
    await cubit.unbindPass();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (!_unlocked) {
      final kind = context.select<PassSecurityCubit, BiometricKind>(
        (cubit) => cubit.state.kind,
      );
      return Scaffold(
        backgroundColor: context.ninja.canvas,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              NfcPassHeader(
                title: l10n.nfcPass,
                onBack: Navigator.of(context).canPop()
                    ? Navigator.of(context).pop
                    : null,
                backTooltip: l10n.back,
              ),
              Expanded(
                child: _PassLockScreen(
                  kind: kind,
                  busy: _authInFlight,
                  onUnlock: () => unawaited(_promptUnlock()),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return BlocConsumer<NfcPassCubit, NfcPassState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == .codeSent) {
          _showCodeSheet();
        }
        if (state.status == .bound) {
          unawaited(context.read<NfcPassCubit>().claimTurnstilePriority());
        } else {
          unawaited(context.read<NfcPassCubit>().releaseTurnstilePriority());
        }
      },
      builder: (context, state) {
        final cubit = context.read<NfcPassCubit>();
        final hce = context.watch<NfcHceCubit>().state;
        final bound = state.status == .bound;
        return Scaffold(
          backgroundColor: context.ninja.canvas,
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NfcPassHeader(
                  title: l10n.nfcPass,
                  statusLabel: bound ? l10n.nfcPassActiveStatus : null,
                  onBack: Navigator.of(context).canPop()
                      ? Navigator.of(context).pop
                      : null,
                  backTooltip: l10n.back,
                  onSettings: bound ? _openSettings : null,
                  settingsTooltip: l10n.settingsNfcTitle,
                ),
                Expanded(
                  child: NfcPassView(
                    state: state,
                    deviceName: _deviceName,
                    turnstileEmulationOff:
                        hce.loaded && hce.available && !hce.enabled,
                    onConnect: () => unawaited(cubit.bindPass()),
                    onUnbind: () => unawaited(_confirmUnbind()),
                    onEnterCode: _showCodeSheet,
                    onRetry: () => unawaited(cubit.checkBound()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
