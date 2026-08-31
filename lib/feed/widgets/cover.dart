part of 'feed_hero_post.dart';

class _Cover extends StatelessWidget {
  const _Cover({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final url = imageUrl;
    final placeholder = ColoredBox(
      color: colors.onAccentSoft.withValues(alpha: .07),
      child: const SizedBox(height: 184, width: double.infinity),
    );
    if (url == null || url.isEmpty) return placeholder;
    return SizedBox(
      height: 184,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (_, _) => placeholder,
        errorWidget: (_, _, _) => placeholder,
      ),
    );
  }
}
