part of 'nfc_pass_card.dart';

class _NfcCardContent extends StatelessWidget {
  const _NfcCardContent({required this.passId, required this.deviceName});

  final String passId;
  final String deviceName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.ninja;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.nfcPassIdLabel,
            style: NinjaText.microLabel.copyWith(
              color: colors.onAccentSoftMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _maskId(passId),
            style: NinjaText.tabular(
              NinjaText.display.copyWith(color: colors.onAccentSoft),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _NfcCardField(
                  label: l10n.nfcPassDeviceLabel,
                  value: deviceName,
                ),
              ),
              const SizedBox(width: 20),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 18),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.onAccentSoft.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(NinjaRadius.control),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const _NfcReadyIndicator(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.nfcPassActiveStatus,
                          style: NinjaText.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.onAccentSoft,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.nfcPassTapHint.replaceAll('\n', ' '),
                          style: NinjaText.helper.copyWith(
                            color: colors.onAccentSoftMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _maskId(String id) {
    if (id.length <= 4) return id;
    final first = id.substring(0, 2);
    final last = id.substring(id.length - 2);
    return '$first ${'•' * (id.length - 4).clamp(2, 6)} $last';
  }
}
