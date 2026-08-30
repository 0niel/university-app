part of '../schedule_page.dart';

class _LessonExtraRow extends StatelessWidget {
  const _LessonExtraRow({
    this.child,
    this.text,
    this.dimmed = false,
    this.foreground,
  });

  final Widget? child;
  final String? text;
  final bool dimmed;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final label = text;
    var content =
        child ??
        Text(
          label ?? '',
          maxLines: 2,
          overflow: .ellipsis,
          style: NinjaText.subtext.copyWith(
            color: foreground ?? colors.muted,
          ),
        );
    if (dimmed) content = Opacity(opacity: 0.45, child: content);

    return Padding(
      padding: const .only(top: 10),
      child: content,
    );
  }
}
