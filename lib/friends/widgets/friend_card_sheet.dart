part of 'ninja_friends_panel.dart';

class FriendCardSheet extends StatelessWidget {
  const FriendCardSheet({required this.friend, super.key});

  final Friend friend;

  String? get _subtitle {
    final handle = friend.handle;
    final group = friend.group;
    final parts = <String>[
      if (handle != null && handle.isNotEmpty)
        '@${handle.replaceFirst('@', '')}',
      if (group != null && group.isNotEmpty) group,
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final subtitle = _subtitle;
    return Column(
      mainAxisSize: .min,
      children: [
        AppAvatar(name: friend.fullName, size: FriendsLayout.detailAvatar),
        const SizedBox(height: AppSpacing.md),
        Text(
          friend.fullName,
          textAlign: .center,
          style: AppText.title.copyWith(color: colors.ink),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            textAlign: .center,
            style: AppText.subtext.copyWith(color: colors.muted),
          ),
        ],
        const SizedBox(height: AppSpacing.screen),
        Column(
          spacing: 10,
          children: [
            FriendsPillButton(
              label: l10n.friendsRemove,
              tone: .danger,
              expanded: true,
              onTap: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ],
    );
  }
}
