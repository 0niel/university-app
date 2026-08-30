part of '../schedule_details_page.dart';

class _MaterialText extends StatelessWidget {
  const _MaterialText({required this.material, this.compact = false});

  final LessonMaterial material;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        Text(
          material.title,
          maxLines: 1,
          overflow: .ellipsis,
          style: NinjaText.body.copyWith(color: colors.ink),
        ),
        const SizedBox(height: 3),
        Text(
          '${material.authorName} · '
          '${_relativeWhen(context.l10n, material.createdAt)}',
          maxLines: 1,
          overflow: .ellipsis,
          style: NinjaText.subtext.copyWith(
            fontSize: 11.5,
            color: colors.muted,
          ),
        ),
        if (!compact) ...[
          const SizedBox(height: 6),
          _MaterialMeta(material: material),
        ],
      ],
    );
  }
}
