part of 'nfc_pass_view.dart';

class _NfcPassScrollable extends StatelessWidget {
  const _NfcPassScrollable({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        NinjaMetrics.screenPadding,
        NinjaMetrics.screenPadding,
        NinjaMetrics.screenPadding + MediaQuery.paddingOf(context).bottom,
      ),
      child: child,
    );
  }
}
