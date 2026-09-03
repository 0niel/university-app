part of 'nfc_pass_view.dart';

class _NfcPassBoundBody extends StatelessWidget {
  const _NfcPassBoundBody({
    required this.passId,
    required this.localFilePath,
    required this.isVideo,
    required this.emulationOff,
  });

  final String passId;
  final String? localFilePath;
  final bool isVideo;
  final bool emulationOff;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (emulationOff)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: NinjaBanner(
              tone: NinjaBannerTone.warn,
              title: l10n.settingsNfcEmulation,
              body: l10n.settingsNfcEmulationSub,
            ),
          ),
        NfcPassCard(
          passId: passId,
          localFilePath: localFilePath,
          isVideo: isVideo,
        ),
      ],
    );
  }
}
