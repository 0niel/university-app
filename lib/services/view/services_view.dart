import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/tab_reselect_notifier.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/services/view/services_community_section.dart';
import 'package:rtu_mirea_app/services/view/services_header.dart';
import 'package:rtu_mirea_app/services/view/services_now_section.dart';
import 'package:rtu_mirea_app/services/view/services_pinned_section.dart';
import 'package:rtu_mirea_app/services/view/services_search_bar.dart';
import 'package:rtu_mirea_app/services/view/services_section_group.dart';
import 'package:rtu_mirea_app/services/view/services_section_skeleton.dart';
import 'package:rtu_mirea_app/top_discussions/top_discussions.dart';
import 'package:rtu_mirea_app/tour/tour.dart';
import 'package:service_catalog_repository/service_catalog_repository.dart';

class ServicesView extends StatefulWidget {
  const ServicesView({super.key, this.initialEditMode = false});

  final bool initialEditMode;

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  static const ServiceLayoutRepository _layoutRepository =
      ServiceLayoutRepository();

  late final DiscourseBloc _discourseBloc;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Map<String, List<String>>? _savedLayout;
  String _query = '';
  late bool _editMode;

  bool _catalogLoadRequested = false;

  @override
  void initState() {
    super.initState();
    _editMode = widget.initialEditMode;
    _discourseBloc = DiscourseBloc(
      context.read(),
    )..add(const DiscourseTopTopicsRequested());
    _searchController.addListener(_onQueryChanged);
    TabReselectNotifier.instance.addListener(_onTabReselect);
    unawaited(_loadLayout());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_catalogLoadRequested) {
      _catalogLoadRequested = true;
      unawaited(
        context.read<ServiceCatalogCubit>().load(
          locale: Localizations.localeOf(context).languageCode,
        ),
      );
    }
  }

  void _onTabReselect() {
    if (TabReselectNotifier.instance.tabIndex != 3) return;
    if (_scrollController.positions.length != 1) return;
    final position = _scrollController.position;
    if (!position.hasContentDimensions) return;
    unawaited(
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  Future<void> _loadLayout() async {
    final saved = await _layoutRepository.load();
    if (!mounted || saved == null) return;
    setState(() => _savedLayout = saved);
  }

  void _onQueryChanged() {
    final value = _searchController.text.trim();
    if (value != _query) setState(() => _query = value);
  }

  void _clearSearch() => _searchController.clear();

  @override
  void dispose() {
    TabReselectNotifier.instance.removeListener(_onTabReselect);
    _scrollController.dispose();
    _searchController
      ..removeListener(_onQueryChanged)
      ..dispose();
    unawaited(_discourseBloc.close());
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _discourseBloc.add(const DiscourseTopTopicsRequested());
    await Future.wait([
      _discourseBloc.stream.firstWhere(
        (state) => state.status == .loaded || state.status == .failure,
      ),
      context.read<ServiceCatalogCubit>().load(
        locale: Localizations.localeOf(context).languageCode,
      ),
    ]);
  }

  ServiceSectionsBuilder _builder(ServiceCatalog? catalog) =>
      ServiceSectionsBuilder(catalog: catalog, savedLayout: _savedLayout);

  @override
  void didUpdateWidget(covariant ServicesView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialEditMode != widget.initialEditMode) {
      _editMode = widget.initialEditMode;
    }
  }

  void _toggleEditMode() {
    final next = !_editMode;
    setState(() => _editMode = next);
    if (!next && widget.initialEditMode) context.replace('/services');
  }

  void _toggleFavorite(ServiceModel service) {
    unawaited(context.read<FavoriteServicesCubit>().toggle(service));
  }

  void _moveService(String id, String toKey, {String? beforeId}) {
    if (id == beforeId) return;
    final next = _builder(context.read<ServiceCatalogCubit>().state.catalog)
        .moved(
          context,
          id: id,
          toKey: toKey,
          beforeId: beforeId,
        );
    if (next == null) return;
    setState(() => _savedLayout = next);
    unawaited(_layoutRepository.save(next));
    unawaited(HapticFeedback.selectionClick());
  }

  bool _matchesQuery(ServiceModel service) =>
      _query.isEmpty ||
      service.title.toLowerCase().contains(_query.toLowerCase());

  bool _isFavorite(ServiceModel service) {
    final id = FavoriteServicesRepository.idOf(
      routePath: service.routePath,
      url: service.url,
    );
    return id != null &&
        context.read<FavoriteServicesCubit>().state.ids.contains(id);
  }

  List<ServiceModel> _pinned(List<ServiceSection> sections) {
    final seen = <String>{};
    final pinned = <ServiceModel>[];
    for (final service in sections.expand((section) => section.services)) {
      if (!_isFavorite(service) || !_matchesQuery(service)) continue;
      final id = FavoriteServicesRepository.idOf(
        routePath: service.routePath,
        url: service.url,
      );
      if (id == null || !seen.add(id)) continue;
      pinned.add(service);
    }
    return pinned;
  }

  void _onServiceTap(ServiceModel service) {
    if (_editMode) {
      _toggleFavorite(service);
    } else {
      ServiceUtils.navigateToService(context, service);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FavoriteServicesCubit>();
    return BlocProvider.value(
      value: _discourseBloc,
      child: BlocBuilder<ServiceCatalogCubit, ServiceCatalogState>(
        builder: (context, state) {
          final sections = _builder(state.catalog).sections(context);
          final pinned = _pinned(sections);
          final colors = context.ninja;
          return RefreshIndicator(
            onRefresh: _onRefresh,
            backgroundColor: colors.surface,
            color: colors.brand,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: ServicesHeader(
                    editMode: _editMode,
                    onToggleEdit: _toggleEditMode,
                  ),
                ),
                SliverToBoxAdapter(
                  child: AppTourAnchor(
                    target: .servicesCatalog,
                    child: ServicesSearchBar(controller: _searchController),
                  ),
                ),
                if (_editMode)
                  const SliverToBoxAdapter(child: ServicesEditHint()),
                if (_query.isEmpty)
                  const SliverToBoxAdapter(child: ServicesNowSection()),
                if (pinned.isNotEmpty || _editMode)
                  SliverToBoxAdapter(
                    child: ServicesPinnedSection(
                      services: pinned,
                      editMode: _editMode,
                      onServiceTap: _onServiceTap,
                    ).animateSectionEntrance(),
                  ),
                ..._sectionSlivers(sections),
                if (state.isLoading && state.catalog == null)
                  const SliverToBoxAdapter(child: ServicesSectionSkeleton()),
                const SliverToBoxAdapter(child: ServicesCommunitySection()),
              ],
            ).animatePageEntrance(),
          );
        },
      ),
    );
  }

  List<Widget> _sectionSlivers(List<ServiceSection> sections) {
    final canDrag = servicesCanDrag(query: _query, editMode: _editMode);
    final visible = <({ServiceSection section, List<ServiceModel> services})>[];
    for (final section in sections) {
      final services = section.services.where(_matchesQuery).toList();
      if (services.isEmpty) continue;
      visible.add((section: section, services: services));
    }

    if (visible.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: NinjaStateSwitcher(
            child: KeyedSubtree(
              key: const ValueKey('services-search-empty'),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  NinjaMetrics.screenPadding,
                  8,
                  NinjaMetrics.screenPadding,
                  24,
                ),
                child: Builder(
                  builder: (context) => NinjaEmptyState(
                    icon: const AppLineIconWidget(AppLineIcon.search),
                    title: context.l10n.searchNoResults,
                    message: context.l10n.searchNoResultsHint,
                    actionLabel: context.l10n.clear,
                    onAction: _clearSearch,
                  ).animateEmptyState(),
                ),
              ),
            ),
          ),
        ),
      ];
    }

    return [
      SliverList.builder(
        itemCount: visible.length,
        itemBuilder: (context, index) {
          final entry = visible[index];
          return ServicesSectionGroup(
            section: entry.section,
            services: entry.services,
            draggable: canDrag,
            editMode: _editMode,
            onFavoriteCheck: _isFavorite,
            onServiceTap: _onServiceTap,
            onMoveService: _moveService,
          ).animateSectionEntrance(index: index);
        },
      ),
    ];
  }
}

bool servicesCanDrag({required String query, required bool editMode}) =>
    query.isEmpty && editMode;
