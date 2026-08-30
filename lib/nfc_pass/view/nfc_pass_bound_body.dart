part of 'nfc_pass_view.dart';

class _NfcPassBoundBody extends StatelessWidget {
  const _NfcPassBoundBody({
    required this.passId,
    required this.deviceName,
    required this.localFilePath,
    required this.isVideo,
    required this.emulationOff,
    required this.onUnbind,
  });

  final String passId;
  final String deviceName;
  final String? localFilePath;
  final bool isVideo;
  final bool emulationOff;
  final VoidCallback onUnbind;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (emulationOff)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: NinjaBanner(
              tone: NinjaBannerTone.warn,
              title: l10n.settingsNfcEmulation,
              body: l10n.settingsNfcEmulationSub,
            ),
          ),
        NfcPassCard(
          passId: passId,
          deviceName: deviceName,
          localFilePath: localFilePath,
          isVideo: isVideo,
        ),
        const SizedBox(height: 18),
        NinjaButton.destructiveOutline(
          label: l10n.nfcPassUnbindButton,
          size: NinjaButtonSize.large,
          expanded: true,
          onPressed: onUnbind,
        ),
      ],
    );
  }
}
