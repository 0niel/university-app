part of 'nfc_pass_view.dart';

class _NfcPassCodeSentBody extends StatelessWidget {
  const _NfcPassCodeSentBody({required this.onEnterCode});

  final VoidCallback onEnterCode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _NfcPassScrollable(
      child: NinjaEmptyState(
        icon: const AppLineIconWidget(AppLineIcon.mail),
        title: l10n.nfcPassCheckEmailTitle,
        message: l10n.nfcPassCheckEmailDescription,
        actionLabel: l10n.nfcPassEnterCodeButton,
        onAction: onEnterCode,
      ).animateEmptyState(),
    );
  }
}
