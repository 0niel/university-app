part of 'nfc_pass_card.dart';

class _NfcCardContent extends StatelessWidget {
  const _NfcCardContent({
    required this.passId,
  });

  final String passId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final foreground = colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _scrim(
          context,
          key: const ValueKey('nfc-pass-header-scrim'),
          atTop: true,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'NFC PASS',
                  style: AppText.overline.copyWith(color: foreground),
                ),
              ),
              AppLineIconWidget(
                AppLineIcon.contactless,
                color: foreground,
                size: AppIconSize.lg,
              ),
            ],
          ),
        ),
        const Spacer(),
        _scrim(
          context,
          key: const ValueKey('nfc-pass-footer-scrim'),
          atTop: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _maskId(passId),
                style: AppText.code.copyWith(color: foreground),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.nfcPassTapHint.replaceAll('\n', ' '),
                style: AppText.caption.copyWith(color: foreground),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _scrim(
    BuildContext context, {
    required Key key,
    required bool atTop,
    required Widget child,
  }) {
    final scrim = context.colors.scrim.withValues(
      alpha: NfcPassCard.textScrimOpacity,
    );
    final fade = SizedBox(
      height: AppSpacing.xxxlg,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: atTop ? Alignment.topCenter : Alignment.bottomCenter,
            end: atTop ? Alignment.bottomCenter : Alignment.topCenter,
            colors: [scrim, scrim.withValues(alpha: 0)],
          ),
        ),
      ),
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          top: atTop ? 0 : -AppSpacing.xxxlg,
          bottom: atTop ? -AppSpacing.xxxlg : 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!atTop) fade,
              Expanded(
                child: ColoredBox(key: key, color: scrim),
              ),
              if (atTop) fade,
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.xlg),
          child: child,
        ),
      ],
    );
  }

  String _maskId(String id) {
    if (id.length <= 4) return id;
    final first = id.substring(0, 2);
    final last = id.substring(id.length - 2);
    return '$first ${'•' * (id.length - 4).clamp(2, 6)} $last';
  }
}
