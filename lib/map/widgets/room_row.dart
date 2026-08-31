part of 'map_room_finder.dart';

class _RoomRow extends StatelessWidget {
  const _RoomRow({required this.room, required this.onTap});

  final RoomModel room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final name = room.name.isEmpty ? room.roomId : room.name;
    final subtitle = room.roomId == name ? null : room.roomId;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: subtitle == null ? name : '$name, $subtitle',
      semanticsButton: true,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        padding: const .all(16),
        child: Row(
          children: [
            Container(
              width: NinjaMetrics.minTouchTarget,
              height: NinjaMetrics.minTouchTarget,
              alignment: .center,
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                shape: .circle,
              ),
              child: AppLineIconWidget(
                .door,
                size: 20,
                color: colors.brandInk,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: NinjaText.headline.copyWith(color: colors.ink),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: NinjaText.subtext.copyWith(color: colors.muted),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            AppLineIconWidget(.chevronR, size: 16, color: colors.chevron),
          ],
        ),
      ),
    );
  }
}
