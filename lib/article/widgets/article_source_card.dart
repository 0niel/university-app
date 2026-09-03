import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_repository/news_repository.dart';
import 'package:rtu_mirea_app/article/cubit/cubit.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/feed/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ArticleSourceCard extends StatelessWidget {
  const ArticleSourceCard({
    required this.sourceName,
    super.key,
    this.categoryId,
  });

  final String sourceName;
  final String? categoryId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final categoryId = this.categoryId;
    final sources = context.select<CategoriesBloc, List<NewsSourceItem>>(
      (bloc) => bloc.state.sources,
    );
    final source = categoryId == null
        ? null
        : feedSourceByKey(sources, categoryId);
    final name = source == null ? sourceName : feedSourceName(source);
    final followKey = categoryId ?? name;
    final followed = context.select<FollowedSourcesCubit, bool>(
      (cubit) => cubit.isFollowed(followKey),
    );
    final subscribers = source?.subscribers;
    final meta = [
      _typeLabel(l10n, source?.sourceType),
      if (subscribers != null && subscribers.trim().isNotEmpty)
        l10n.articleSourceSubscribers(subscribers.trim()),
    ].join(' · ');

    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.fieldGap,
        AppSpacing.lg,
        AppSpacing.fieldGap,
        AppSpacing.lg,
      ),
      child: Row(
        children: [
          AppAvatar(
            name: name,
            size: 44,
            color: colors.accent,
            imageUrl: source?.avatarUrl,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.headlineStrong.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  meta,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.subtext.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          AppButton(
            key: const Key('article_followButton'),
            label: followed
                ? l10n.articleSourceSubscribed
                : l10n.articleSourceSubscribe,
            variant: followed
                ? AppButtonVariant.secondary
                : AppButtonVariant.primary,
            size: AppButtonSize.small,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sectionGap,
            ),
            onPressed: () {
              context.read<FollowedSourcesCubit>().toggle(followKey);
              if (followed) {
                ToastManager.showInfo(
                  context,
                  message: l10n.articleSourceUnfollowedToast,
                );
              } else {
                ToastManager.showSuccess(
                  context,
                  message: l10n.articleSourceFollowedToast(name),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String _typeLabel(AppLocalizations l10n, String? type) => switch (type) {
    'telegram' || 'telegram_stories' => l10n.articleSourceTelegram,
    'rss' => l10n.articleSourceRss,
    _ => l10n.articleSourceChannel,
  };
}
