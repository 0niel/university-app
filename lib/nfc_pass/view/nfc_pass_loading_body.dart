part of 'nfc_pass_view.dart';

class _NfcPassLoadingBody extends StatelessWidget {
  const _NfcPassLoadingBody();

  @override
  Widget build(BuildContext context) {
    return const NinjaSkeletonGroup(
      child: _NfcPassScrollable(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NinjaSkeleton(height: 232, radius: NinjaRadius.card),
            SizedBox(height: 18),
            NinjaSkeleton(height: 52, radius: NinjaRadius.pill),
          ],
        ),
      ),
    );
  }
}
