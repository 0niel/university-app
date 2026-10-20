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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: NfcPassCard.maxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NfcPassCard(
              passId: passId,
              localFilePath: localFilePath,
              isVideo: isVideo,
              emulationOff: emulationOff,
            ),
            if (emulationOff)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: NinjaBanner(
                  tone: NinjaBannerTone.warn,
                  title: l10n.settingsNfcEmulation,
                  body: l10n.settingsNfcEmulationSub,
                ),
              ),
            if (!emulationOff)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xlg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLineIconWidget(
                      AppLineIcon.contactless,
                      size: AppIconSize.md,
                      color: context.colors.muted,
                    ),
                    const SizedBox(width: AppSpacing.gap),
                    Flexible(
                      child: Text(
                        l10n.nfcPassTapHint.replaceAll('\n', ' '),
                        style: AppText.body.copyWith(
                          color: context.colors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
