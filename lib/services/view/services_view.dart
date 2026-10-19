import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/tab_reselect_notifier.dart';
import 'package:rtu_mirea_app/nfc_pass/nfc_pass_availability.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/search/view/search_sheet.dart';
import 'package:rtu_mirea_app/services/cubit/cubit.dart';
import 'package:rtu_mirea_app/services/data/services_directory.dart';
import 'package:rtu_mirea_app/services/models/service_entry.dart';
import 'package:rtu_mirea_app/services/view/widgets/services_feature_card.dart';
import 'package:rtu_mirea_app/services/view/widgets/services_grid_skeleton.dart';
import 'package:rtu_mirea_app/services/view/widgets/services_nfc_card.dart';
import 'package:rtu_mirea_app/services/view/widgets/services_section.dart';
import 'package:rtu_mirea_app/tour/tour.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ServicesView extends StatefulWidget {
  const ServicesView({super.key, this.initialEditMode = false});

  final bool initialEditMode;

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  final ScrollController _scrollController = ScrollController();
  late bool _editMode = widget.initialEditMode;
  bool _catalogLoadRequested = false;
  String? _sectionKey;

  @override
  void initState() {
    super.initState();
    TabReselectNotifier.instance.addListener(_onTabReselect);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_catalogLoadRequested) return;
    _catalogLoadRequested = true;
    unawaited(
      context.read<ServiceCatalogCubit>().load(
        locale: Localizations.localeOf(context).languageCode,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ServicesView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialEditMode != widget.initialEditMode) {
      _editMode = widget.initialEditMode;
    }
  }

  @override
  void dispose() {
    TabReselectNotifier.instance.removeListener(_onTabReselect);
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabReselect() {
    if (TabReselectNotifier.instance.tabIndex != 3) return;
    if (_scrollController.positions.length != 1) return;
    final position = _scrollController.position;
    if (!position.hasContentDimensions) return;
    if (MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context)) {
      _scrollController.jumpTo(0);
      return;
    }
    unawaited(
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      ),
    );
  }

  void _toggleEditMode() {
    final next = !_editMode;
    setState(() => _editMode = next);
    if (!next && widget.initialEditMode) context.replace('/services');
  }

  void _toggleFavorite(ServiceEntry entry) {
    unawaited(context.read<FavoriteServicesCubit>().toggle(entry.model));
  }

  void _open(ServiceEntry entry) {
    if (_editMode) {
      _toggleFavorite(entry);
    } else {
      entry.open(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final favorites = context.watch<FavoriteServicesCubit>().state;
    final catalogState = context.watch<ServiceCatalogCubit>().state;
    final config = context.read<UniversityConfig>();
    final examDays = context.select<ScheduleBloc, int?>(
      (bloc) => nearestExamDays(bloc.state.selectedSchedule?.schedule),
    );
    final sections = ServicesDirectory.sections(
      context,
      config: config,
      catalog: catalogState.catalog,
      examDays: examDays,
    );
    final loadingCatalog =
        catalogState.isLoading && catalogState.catalog == null;

    final showNfc =
        NfcPassAvailability.isSupported && config.isEnabled(.nfcPass);
    final entries = sections.expand((section) => section.entries).toList();
    final feature = entries
        .where(
          (entry) => entry.model.routePath == '/services/apps',
        )
        .firstOrNull;
    final pinned = ServicesDirectory.orderedEntries(entries, favorites.ids)
        .where(
          (entry) =>
              entry.id != feature?.id &&
              (!showNfc || entry.model.routePath != '/services/nfc'),
        )
        .toList();
    const quickRoutes = [
      '/services/map',
      '/services/free-rooms',
      '/services/deadlines',
      '/services/collab-notes',
    ];
    final quick = <ServiceEntry>[
      for (final path in quickRoutes)
        for (final entry in entries)
          if (entry.model.routePath == path) entry,
    ];
    final spotlight = pinned.isNotEmpty ? pinned : quick;
    final highlighted = {
      feature?.id,
      ...spotlight.map((entry) => entry.id),
      if (showNfc) '/services/nfc',
    };
    final selected = sections
        .where((section) => section.key == _sectionKey)
        .firstOrNull;
    final catalog =
        selected ??
        ServiceSectionEntries(
          key: 'all',
          title: l10n.servicesSectionAll,
          entries: entries
              .where((entry) => !highlighted.contains(entry.id))
              .toList(),
        );
    return AppAmbientBackground(
      child: CustomScrollView(
        controller: _scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            sliver: SliverList.list(
              children: [
                AppScreenHeader(
                  title: l10n.services,
                  padding: EdgeInsets.only(
                    top: math.max(
                      AppSpacing.screenTop,
                      MediaQuery.paddingOf(context).top + 12,
                    ),
                  ),
                  textAction: AppHeaderTextAction(
                    key: const ValueKey('services-edit-toggle'),
                    onTap: _toggleEditMode,
                    label: _editMode
                        ? l10n.servicesEditDone
                        : l10n.servicesConfigure,
                  ),
                ),
                const SizedBox(height: AppSpacing.gap),
                AppTourAnchor(
                  target: .servicesCatalog,
                  child: AppSearchBar.button(
                    key: const ValueKey('services-search'),
                    hintText: l10n.servicesSearchPlaceholder,
                    isOnCanvas: true,
                    trailingIcon: null,
                    onTap: () => unawaited(showSearchSheet(context)),
                  ),
                ),
                if (catalogState.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: AppBanner(
                      key: const ValueKey('services-catalog-error'),
                      message: l10n.loadingError,
                      tone: AppBannerTone.warn,
                      actionLabel: l10n.retry,
                      onAction: () => unawaited(
                        context.read<ServiceCatalogCubit>().load(
                          locale: Localizations.localeOf(context).languageCode,
                        ),
                      ),
                    ),
                  ),
                AnimatedSize(
                  duration: NinjaMotion.of(context),
                  curve: NinjaMotion.enter,
                  alignment: Alignment.topCenter,
                  child: _editMode
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: AppBanner(
                            key: const ValueKey('services-edit-banner'),
                            message: l10n.servicesEditBanner,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                if (selected == null) ...[
                  if (feature != null) ...[
                    const SizedBox(height: AppSpacing.gap),
                    ServicesFeatureCard(
                      entry: feature,
                      editMode: _editMode,
                      favorite: favorites.ids.contains(feature.id),
                      onTap: () => _open(feature),
                      onToggleFavorite: () => _toggleFavorite(feature),
                    ),
                  ],
                  if (showNfc) ...[
                    const SizedBox(height: AppSpacing.sm),
                    const ServicesNfcCard(),
                  ],
                ],
              ],
            ),
          ),
          if (selected == null && spotlight.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              sliver: ServicesSection.sliver(
                key: const ValueKey('services-spotlight'),
                section: ServiceSectionEntries(
                  key: pinned.isEmpty ? 'quick' : 'pinned',
                  title: pinned.isEmpty
                      ? l10n.servicesSectionImportant
                      : l10n.servicesSectionPinned,
                  entries: spotlight,
                ),
                editMode: _editMode,
                isFavorite: (entry) => favorites.ids.contains(entry.id),
                onOpen: _open,
                onToggleFavorite: _toggleFavorite,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
          SliverToBoxAdapter(
            child: AppChipRow<String?>(
              key: const ValueKey('services-categories'),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              value: selected?.key,
              style: AppChipStyle.tinted,
              spacing: AppSpacing.sm,
              onChanged: (value) => setState(() => _sectionKey = value),
              items: [
                AppChipRowItem(
                  key: const ValueKey('services-category-all'),
                  value: null,
                  label: l10n.servicesSectionAll,
                ),
                for (final section in sections)
                  AppChipRowItem(
                    key: ValueKey('services-category-${section.key}'),
                    value: section.key,
                    label: section.title,
                  ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screen,
              0,
              AppSpacing.screen,
              AppBottomBar.extentOf(context) + AppSpacing.screen,
            ),
            sliver: SliverMainAxisGroup(
              slivers: [
                ServicesSection.sliver(
                  key: ValueKey('services-section-${catalog.key}'),
                  section: catalog,
                  editMode: _editMode,
                  isFavorite: (entry) => favorites.ids.contains(entry.id),
                  onOpen: _open,
                  onToggleFavorite: _toggleFavorite,
                ),
                if (loadingCatalog)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: ServicesGridSkeleton(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

int? nearestExamDays(List<SchedulePart>? schedule) {
  if (schedule == null) return null;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  DateTime? nearest;
  for (final lesson in schedule.whereType<LessonSchedulePart>()) {
    if (switch (lesson.lessonType) {
      LessonType.exam || LessonType.credit => false,
      LessonType.practice ||
      LessonType.lecture ||
      LessonType.laboratoryWork ||
      LessonType.individualWork ||
      LessonType.physicalEducation ||
      LessonType.consultation ||
      LessonType.courseWork ||
      LessonType.courseProject ||
      LessonType.unknown => true,
    }) {
      continue;
    }
    for (final date in lesson.dates) {
      if (date.isBefore(today)) continue;
      if (nearest == null || date.isBefore(nearest)) nearest = date;
    }
  }
  return nearest?.difference(today).inDays;
}
