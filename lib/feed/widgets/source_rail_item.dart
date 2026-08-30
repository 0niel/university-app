part of 'feed_sources_rail.dart';

class _SourceRailItem extends StatelessWidget {
  const _SourceRailItem({required this.source});

  final NewsSourceItem source;

  static const double _avatarSize = 56;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final avatarUrl = source.avatarUrl;
    final name = source.sourceName.trim().isEmpty
        ? source.sourceId
        : source.sourceName;
    final fallback = NinjaAvatar(
      initials: _initials(name),
      size: _avatarSize,
    );

    return AppPressable(
      semanticsLabel: name,
      semanticsButton: true,
      onTap: () {
        final key = newsCategoryKey(source.sourceType, source.sourceId);
        final categories =
            context.read<CategoriesBloc>().state.categories ?? [];
        final category = categories.firstWhere(
          (candidate) => candidate.id == key,
          orElse: () => Category(id: key, name: name),
        );
        context.read<CategoriesBloc>().add(
          CategorySelected(category: category),
        );
      },
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            if (avatarUrl != null && avatarUrl.isNotEmpty)
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: avatarUrl,
                  width: _avatarSize,
                  height: _avatarSize,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => fallback,
                  errorWidget: (_, _, _) => fallback,
                ),
              )
            else
              fallback,
            const SizedBox(height: AppSpacing.sm),
            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: NinjaText.helper.copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    final letters = words
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join();
    return letters.isEmpty ? '?' : letters;
  }
}
