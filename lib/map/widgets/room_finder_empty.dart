part of 'map_room_finder.dart';

class _RoomFinderEmpty extends StatelessWidget {
  const _RoomFinderEmpty({required this.onReset, super.key});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
      child: Column(
        mainAxisSize: .min,
        children: [
          NinjaEmptyState(
            title: l10n.mapNoRoomsTitle,
            message: l10n.mapNoRoomsMessage,
            icon: const AppLineIconWidget(.door, size: 24),
          ),
          const SizedBox(height: 14),
          NinjaChip(label: l10n.clear, selected: true, onTap: onReset),
        ],
      ).animateEmptyState(),
    );
  }
}
