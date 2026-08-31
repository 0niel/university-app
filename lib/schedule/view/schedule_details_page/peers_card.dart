part of '../schedule_details_page.dart';

class _PeersCard extends StatelessWidget {
  const _PeersCard({required this.peers});

  final List<GroupMember> peers;

  static const int _maxAvatars = 5;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final shown = peers.take(_maxAvatars).toList();
    final friendsCount = peers.where((peer) => peer.isFriend).length;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _SectionTitle(
          title: context.l10n.lessonDetailsPeersTitle,
          action: '${peers.length}',
        ),
        Padding(
          padding: const .fromLTRB(
            NinjaMetrics.screenPadding,
            0,
            NinjaMetrics.screenPadding,
            18,
          ),
          child: Row(
            children: [
              NinjaAvatarGroup(
                overflowCount: peers.length - shown.length,
                items: [
                  for (final peer in shown)
                    NinjaAvatarGroupItem(_initialsOf(peer.fullName)),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.l10n.lessonDetailsPeersFriends(friendsCount),
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: NinjaText.subtext.copyWith(
                    color: friendsCount > 0 ? colors.brandInk : colors.muted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
