part of '../people_widgets.dart';

class FriendRequestRow extends StatelessWidget {
  const FriendRequestRow({
    required this.request,
    required this.pending,
    required this.onRespond,
    super.key,
  });

  final FriendRequest request;
  final bool pending;
  final Future<void> Function({
    required String friendshipId,
    required bool accept,
  })
  onRespond;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final group = request.group;
    return Container(
      padding: const .all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Row(
        children: [
          NinjaAvatar(initials: ninjaInitials(request.fullName)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  request.fullName,
                  overflow: .ellipsis,
                  style: AppText.body.copyWith(color: colors.ink),
                ),
                if (group != null)
                  Text(
                    group,
                    style: AppText.caption.copyWith(
                      color: colors.muted,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          NinjaIconButton(
            icon: const AppLineIconWidget(.check, size: 20),
            tooltip: context.l10n.friendsAccept,
            onPressed: pending
                ? null
                : () {
                    unawaited(HapticFeedback.lightImpact());
                    unawaited(
                      onRespond(
                        friendshipId: request.friendshipId,
                        accept: true,
                      ),
                    );
                  },
          ),
          const SizedBox(width: 6),
          NinjaIconButton(
            icon: const AppLineIconWidget(.close, size: 20),
            tooltip: context.l10n.friendsDecline,
            onPressed: pending
                ? null
                : () {
                    unawaited(HapticFeedback.lightImpact());
                    unawaited(
                      onRespond(
                        friendshipId: request.friendshipId,
                        accept: false,
                      ),
                    );
                  },
          ),
        ],
      ),
    );
  }
}
