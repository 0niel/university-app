part of '../schedule_details_page.dart';

class _TeacherRow extends StatelessWidget {
  const _TeacherRow({
    required this.teacher,
    this.profile,
  });

  final Teacher teacher;
  final TeacherProfile? profile;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final name = teacher.name;
    final post = teacher.post ?? l10n.lessonDetailsTeacherFallback;
    final rating = profile?.overall;
    final trailing = rating != null
        ? '★ ${NumberFormat('0.0', l10n.localeName).format(rating)}'
        : l10n.lessonDetailsTeacherProfile;

    return NinjaScheduleSurface(
      onTap: () {
        unawaited(
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => TeacherProfilePage(teacherName: name),
            ),
          ),
        );
      },
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          NinjaAvatar(initials: _initialsOf(name)),
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
                  style: NinjaText.body.copyWith(color: colors.ink),
                ),
                const SizedBox(height: 2),
                Text(
                  post,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: NinjaText.subtext.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            trailing,
            style: NinjaText.subtext.copyWith(color: colors.muted),
          ),
          const SizedBox(width: 6),
          NinjaGlyphIcon(
            NinjaGlyph.chevronRight,
            size: 14,
            color: colors.chevron,
            strokeWidth: 2.5,
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
