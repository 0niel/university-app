part of 'free_rooms_view.dart';

class _FreeRoomsMessage extends StatelessWidget {
  const _FreeRoomsMessage({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        8,
        NinjaMetrics.screenPadding,
        40,
      ),
      children: [child],
    );
  }
}
