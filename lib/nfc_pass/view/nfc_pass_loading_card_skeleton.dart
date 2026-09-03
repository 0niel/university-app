part of 'nfc_pass_view.dart';

class _NfcPassLoadingCardSkeleton extends StatelessWidget {
  const _NfcPassLoadingCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      child: _NfcPassScrollable(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: NfcPassCard.maxWidth),
            child: const AspectRatio(
              aspectRatio: NfcPassCard.aspectRatio,
              child: NinjaSkeleton(
                height: double.infinity,
                radius: AppRadius.card,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
