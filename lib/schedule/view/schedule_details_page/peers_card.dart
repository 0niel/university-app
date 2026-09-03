part of '../schedule_details_page.dart';

class _PeersCard extends StatelessWidget {
  const _PeersCard({required this.peers});

  final List<GroupMember> peers;

  static const int _maxAvatars = 5;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
            AppSpacing.screen,
            AppSpacing.zero,
            AppSpacing.screen,
            AppSpacing.fieldGap,
          ),
          child: Row(
            children: [
              AppAvatarGroup(
                overflowCount: peers.length - shown.length,
                items: [
                  for (final peer in shown)
                    AppAvatarGroupItem(_initialsOf(peer.fullName)),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  context.l10n.lessonDetailsPeersFriends(friendsCount),
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: AppText.subtext.copyWith(
                    color: friendsCount > 0 ? colors.accent : colors.muted,
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
