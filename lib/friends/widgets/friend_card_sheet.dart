part of 'ninja_friends_panel.dart';

class FriendCardSheet extends StatelessWidget {
  const FriendCardSheet({required this.friend, super.key});

  final Friend friend;

  Future<void> _openTelegram(String handle) async {
    final clean = handle.replaceFirst('@', '').trim();
    if (clean.isEmpty) return;
    await launchUrl(
      Uri.parse('https://t.me/$clean'),
      mode: .externalApplication,
    );
  }

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
    final colors = context.ninja;
    final l10n = context.l10n;
    final handle = friend.handle;
    final hasTelegram = handle != null && handle.isNotEmpty;
    final subtitle = _subtitle;
    return Column(
      mainAxisSize: .min,
      children: [
        NinjaAvatar(initials: ninjaInitials(friend.fullName), size: 64),
        const SizedBox(height: 12),
        Text(
          friend.fullName,
          textAlign: .center,
          style: NinjaText.title.copyWith(color: colors.ink),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: .center,
            style: NinjaText.subtext.copyWith(color: colors.muted),
          ),
        ],
        const SizedBox(height: 20),
        Column(
          spacing: 10,
          children: [
            if (hasTelegram)
              FriendsPillButton(
                label: l10n.friendsWriteTelegram,
                icon: .message,
                expanded: true,
                onTap: () => _openTelegram(handle),
              ),
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
