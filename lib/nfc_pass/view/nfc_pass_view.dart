import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/widgets.dart';

part 'nfc_pass_bound_body.dart';
part 'nfc_pass_code_sent_body.dart';
part 'nfc_pass_loading_body.dart';
part 'nfc_pass_loading_card_skeleton.dart';
part 'nfc_pass_scrollable.dart';

class NfcPassView extends StatefulWidget {
  const NfcPassView({
    required this.state,
    required this.deviceName,
    required this.onConnect,
    required this.onUnbind,
    required this.onEnterCode,
    required this.onRetry,
    super.key,
    this.turnstileEmulationOff = false,
  });

  final NfcPassState state;
  final String deviceName;
  final VoidCallback onConnect;
  final VoidCallback onUnbind;
  final VoidCallback onEnterCode;
  final VoidCallback onRetry;

  final bool turnstileEmulationOff;

  @override
  State<NfcPassView> createState() => _NfcPassViewState();
}

class _NfcPassViewState extends State<NfcPassView> {
  bool _firstLoadPending = true;

  @override
  void didUpdateWidget(NfcPassView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_firstLoadPending && widget.state.status != .loading) {
      _firstLoadPending = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration:
          (MediaQuery.disableAnimationsOf(context) ||
              MediaQuery.accessibleNavigationOf(context))
          ? Duration.zero
          : const Duration(milliseconds: 240),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: KeyedSubtree(
        key: ValueKey(widget.state.status),
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final state = widget.state;
    switch (state.status) {
      case .loading:
        return _firstLoadPending
            ? const _NfcPassLoadingCardSkeleton()
            : const _NfcPassLoadingBody();
      case .initial:
        return _NfcPassScrollable(
          child: NfcNotConnected(onConnect: widget.onConnect),
        );
      case .codeSent:
        return _NfcPassCodeSentBody(onEnterCode: widget.onEnterCode);
      case .bound:
        return _NfcPassScrollable(
          child: _NfcPassBoundBody(
            passId: state.passId?.toString() ?? '—',
            deviceName: widget.deviceName,
            localFilePath: state.localFilePath,
            isVideo: state.isVideo,
            emulationOff: widget.turnstileEmulationOff,
            onUnbind: widget.onUnbind,
          ),
        );
      case .error:
        final l10n = context.l10n;
        final errorMessage = state.errorMessage;
        return _NfcPassScrollable(
          child: NinjaErrorState(
            title: l10n.nfcPassErrorTitle,
            message: errorMessage != null && errorMessage.isNotEmpty
                ? errorMessage
                : l10n.nfcPassErrorDescription,
            retryLabel: l10n.retry,
            onRetry: widget.onRetry,
          ).animateEmptyState(),
        );
    }
  }
}
