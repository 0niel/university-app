import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_repository/news_repository.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'source_rail_item.dart';

class FeedSourcesRail extends StatelessWidget {
  const FeedSourcesRail({super.key});

  @override
  Widget build(BuildContext context) {
    final sources = context.select<CategoriesBloc, List<NewsSourceItem>>(
      (bloc) => bloc.state.sources,
    );
    if (sources.isEmpty) return const SizedBox.shrink();

    final colors = context.ninja;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final railHeight = 104 + (textScale - 1).clamp(0, 1).toDouble() * 32;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            28,
            NinjaMetrics.screenPadding,
            AppSpacing.md,
          ),
          child: Text(
            context.l10n.feedSourcesTitle,
            style: NinjaText.title.copyWith(color: colors.ink),
          ),
        ),
        SizedBox(
          height: railHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: NinjaMetrics.screenPadding,
            ),
            itemCount: sources.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                _SourceRailItem(source: sources[index]),
          ),
        ),
      ],
    );
  }
}
