part of '../schedule_page.dart';

class _FriendsOnClass extends StatelessWidget {
  const _FriendsOnClass({required this.names, this.foreground});

  final List<String> names;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final firstName = names.firstOrNull;
    if (firstName == null) return const SizedBox.shrink();
    final colors = context.ninja;
    final shown = names.take(4).toList();

    return _LessonExtraRow(
      foreground: foreground,
      child: Row(
        children: [
          NinjaAvatarGroup(
            size: 24,
            overlap: 8,
            overflowCount: names.length - shown.length,
            items: [
              for (final name in shown) NinjaAvatarGroupItem(_initialsOf(name)),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.friendsInClass(firstName, names.length - 1),
              maxLines: 1,
              overflow: .ellipsis,
              style: NinjaText.subtext.copyWith(
                color: foreground ?? colors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  final letters = parts.take(2).map((part) => part[0].toUpperCase());
  return letters.isEmpty ? '?' : letters.join();
}
