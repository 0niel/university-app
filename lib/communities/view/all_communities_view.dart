import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/communities/communities.dart';
import 'package:rtu_mirea_app/community/widgets/accent_header_action.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class AllCommunitiesView extends StatefulWidget {
  const AllCommunitiesView({super.key});

  @override
  State<AllCommunitiesView> createState() => _AllCommunitiesViewState();
}

class _AllCommunitiesViewState extends State<AllCommunitiesView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() => context.read<CommunityCatalogCubit>().load(
    locale: Localizations.localeOf(context).toLanguageTag(),
  );

  void _resetFilters() {
    _searchController.clear();
    context.read<CommunityCatalogCubit>()
      ..queryChanged('')
      ..sectionSelected(null);
  }

  Future<void> _search() => showAppSheet<void>(
    context,
    title: context.l10n.search,
    child: AppSearchBar(
      controller: _searchController,
      hintText: context.l10n.communitiesSearchHintInline,
      autofocus: true,
      onChanged: context.read<CommunityCatalogCubit>().queryChanged,
      onSubmitted: (_) => Navigator.of(context, rootNavigator: true).pop(),
    ),
  );

  Future<void> _suggest(String url) async {
    final uri = safeCommunityUri(url);
    var opened = false;
    try {
      if (uri != null) {
        opened = await launchUrl(uri, mode: .externalApplication);
      }
    } on Exception catch (_) {
      opened = false;
    }
    if (!opened && mounted) {
      showNinjaToast(context, message: context.l10n.error, showCheck: false);
    }
  }

  Future<void> _open(CommunityCatalogEntry entry, String category) =>
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider.value(
            value: context.read<JoinedCommunitiesCubit>(),
            child: CommunityDetailPage(entry: entry, categoryTitle: category),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final state = context.watch<CommunityCatalogCubit>().state;
    final cubit = context.read<CommunityCatalogCubit>();
    final suggestion = state.catalog?.suggestionUrl;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: RefreshIndicator(
        color: colors.accent,
        backgroundColor: colors.surface,
        onRefresh: _refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: AppInnerHeader(
                title: l10n.communitiesTitle,
                backSemanticsLabel: l10n.back,
                onBack: () => Navigator.of(context).maybePop(),
                actions: [
                  if (safeCommunityUri(suggestion) != null)
                    accentHeaderAction(
                      semanticsLabel: l10n.communitiesSuggest,
                      onTap: () => unawaited(_suggest(suggestion!)),
                    ),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.screen),
            ),
            if (state.catalog != null)
              SliverToBoxAdapter(
                child: AppChipRow<String?>(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screen,
                  ),
                  items: [
                    AppChipRowItem(value: null, label: l10n.communitiesAll),
                    for (final section in state.catalog!.sections)
                      AppChipRowItem(value: section.key, label: section.title),
                    AppChipRowItem(value: '__search', label: l10n.search),
                  ],
                  value: state.selectedSectionKey,
                  onChanged: (value) => value == '__search'
                      ? unawaited(_search())
                      : cubit.sectionSelected(value),
                ),
              ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.zero,
                AppSpacing.screen,
                ninjaBottomInset(context) + AppSpacing.lg,
              ),
              sliver: SliverToBoxAdapter(
                child: CommunityCatalogContent(
                  state: state,
                  onRetry: () => unawaited(_refresh()),
                  onReset: _resetFilters,
                  onOpen: (entry, category) =>
                      unawaited(_open(entry, category)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
