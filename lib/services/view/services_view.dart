import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/tab_reselect_notifier.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/search/view/search_sheet.dart';
import 'package:rtu_mirea_app/services/cubit/cubit.dart';
import 'package:rtu_mirea_app/services/data/services_directory.dart';
import 'package:rtu_mirea_app/services/models/service_entry.dart';
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

    return CustomScrollView(
      controller: _scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screen,
            0,
            AppSpacing.screen,
            AppBottomBar.extentOf(context) + AppSpacing.screen,
          ),
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
              const SizedBox(height: AppSpacing.fieldGap),
              AppTourAnchor(
                target: .servicesCatalog,
                child: AppSearchBar.button(
                  key: const ValueKey('services-search'),
                  hintText: l10n.servicesSearchPlaceholder,
                  onCanvas: true,
                  trailingIcon: null,
                  onTap: () => unawaited(showSearchSheet(context)),
                ),
              ),
              AnimatedSize(
                duration: NinjaMotion.of(context),
                curve: NinjaMotion.enter,
                alignment: Alignment.topCenter,
                child: _editMode
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: AppSpacing.sectionGap,
                        ),
                        child: AppBanner(
                          key: const ValueKey('services-edit-banner'),
                          message: l10n.servicesEditBanner,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              for (final section in sections) ...[
                ServicesSection(
                  key: ValueKey('services-section-${section.key}'),
                  section: section,
                  editMode: _editMode,
                  isFavorite: (entry) => favorites.ids.contains(entry.id),
                  onOpen: _open,
                  onToggleFavorite: _toggleFavorite,
                ),
                if (section.key == ServicesDirectory.sectionFirstParty &&
                    config.isEnabled(.nfcPass)) ...[
                  const SizedBox(height: AppSpacing.sectionGap),
                  const ServicesNfcCard(),
                ],
              ],
              if (loadingCatalog) ...[
                const SizedBox(height: 22),
                const AppSkeletonGroup(
                  child: AppListGroup(
                    radius: AppRadius.lg,
                    children: [
                      AppSkeletonRow(),
                      AppSkeletonRow(),
                      AppSkeletonRow(),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

int? nearestExamDays(List<SchedulePart>? schedule) {
  if (schedule == null) return null;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  DateTime? nearest;
  for (final lesson in schedule.whereType<LessonSchedulePart>()) {
    if (lesson.lessonType != LessonType.exam &&
        lesson.lessonType != LessonType.credit) {
      continue;
    }
    for (final date in lesson.dates) {
      if (date.isBefore(today)) continue;
      if (nearest == null || date.isBefore(nearest)) nearest = date;
    }
  }
  return nearest?.difference(today).inDays;
}
