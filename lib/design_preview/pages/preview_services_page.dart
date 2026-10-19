import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/design_preview/fixtures/preview_fixtures.dart';
import 'package:rtu_mirea_app/design_preview/fixtures/preview_mini_app_fixtures.dart';
import 'package:rtu_mirea_app/design_preview/fixtures/preview_service_fixtures.dart';
import 'package:rtu_mirea_app/design_preview/pages/preview_mini_apps_page.dart';
import 'package:rtu_mirea_app/design_preview/widgets/preview_page.dart';
import 'package:rtu_mirea_app/design_preview/widgets/preview_text_sheet.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_card.dart';
import 'package:rtu_mirea_app/services/models/service_entry.dart';
import 'package:rtu_mirea_app/services/view/widgets/services_feature_card.dart';
import 'package:rtu_mirea_app/services/view/widgets/services_section.dart';

class PreviewServicesPage extends StatefulWidget {
  const PreviewServicesPage({required this.onTab, super.key});
  final ValueChanged<int> onTab;
  @override
  State<PreviewServicesPage> createState() => _PreviewServicesPageState();
}

class _PreviewServicesPageState extends State<PreviewServicesPage> {
  final _query = TextEditingController();
  final _favorites = <String>{};
  String? _sectionKey;
  String _note = '';
  String _queryText = '';
  bool _editing = false;
  bool _searching = false;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _toggleFavorite(ServiceEntry entry) => setState(() {
    if (!_favorites.add(entry.id)) _favorites.remove(entry.id);
  });

  void _open(ServiceEntry entry) {
    if (_editing) {
      _toggleFavorite(entry);
      return;
    }
    switch (entry.model.routePath) {
      case '/services/apps':
        unawaited(_showMiniApps());
      case '/services/map' || '/services/free-rooms' || '/services/friends':
        widget.onTab(2);
      case '/schedule/session':
        widget.onTab(1);
      case '/profile':
        widget.onTab(4);
      case '/services/deadlines':
        unawaited(
          showAppSheet<void>(
            context,
            title: context.l10n.homeDeadlines,
            child: AppListGroup(
              children: [
                for (final deadline in PreviewFixtures.deadlines)
                  AppListRow(
                    title: deadline.title,
                    subtitle: deadline.subjectName,
                  ),
              ],
            ),
          ),
        );
      default:
        unawaited(_editNote(entry.title));
    }
  }

  Future<void> _editNote(String title) async {
    final value = await showAppSheet<String>(
      context,
      title: title,
      child: PreviewTextSheet(
        label: context.l10n.lessonDetailsNote,
        initialValue: _note,
      ),
    );
    if (value != null && mounted) setState(() => _note = value);
  }

  Future<void> _showMiniApps() {
    final navigator = Navigator.of(context);
    return navigator.push<void>(
      MaterialPageRoute(
        builder: (_) => PreviewMiniAppsPage(
          onOpen: (app) => _showAppInfo(app, onLaunch: navigator.pop),
        ),
      ),
    );
  }

  Future<void> _showAppInfo(MiniApp app, {VoidCallback? onLaunch}) =>
      showAppSheet<void>(
        context,
        title: app.name,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBanner(message: app.description),
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(
              label: context.l10n.miniAppsOpen,
              onPressed: () {
                Navigator.of(context).pop();
                onLaunch?.call();
                if (app.category == MiniAppCategory.campus) {
                  widget.onTab(2);
                } else {
                  unawaited(_editNote(app.name));
                }
              },
            ),
          ],
        ),
      );

  bool _matches(ServiceEntry entry) {
    final query = _queryText.trim().toLowerCase();
    return query.isEmpty ||
        '${entry.title} ${entry.subtitle}'.toLowerCase().contains(query);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sections = PreviewServiceFixtures.sections(context);
    final feature = PreviewServiceFixtures.feature(context);
    final entries = sections.expand((section) => section.entries).toList();
    final selected = sections
        .where((section) => section.key == _sectionKey)
        .firstOrNull;
    final pinned = entries
        .where((entry) => _favorites.contains(entry.id))
        .toList();
    const quickPaths = {
      '/services/map',
      '/services/free-rooms',
      '/services/deadlines',
      '/services/collab-notes',
    };
    final spotlight = pinned.isEmpty
        ? entries
              .where((entry) => quickPaths.contains(entry.model.routePath))
              .toList()
        : pinned;
    final highlighted = spotlight.map((entry) => entry.id).toSet();
    final catalog = ServiceSectionEntries(
      key: selected?.key ?? 'all',
      title: selected?.title ?? l10n.servicesSectionAll,
      entries: [
        for (final entry
            in selected?.entries ??
                entries.where(
                  (candidate) => !highlighted.contains(candidate.id),
                ))
          if (_matches(entry)) entry,
      ],
    );
    final apps = PreviewMiniAppFixtures.apps(l10n)
        .where((app) {
          final matchesSection = switch (_sectionKey) {
            'campus' => app.category == MiniAppCategory.campus,
            'study' => app.category == MiniAppCategory.study,
            'community' => app.category == MiniAppCategory.social,
            _ => true,
          };
          return matchesSection &&
              '${app.name} ${app.description}'.toLowerCase().contains(
                _queryText.trim().toLowerCase(),
              );
        })
        .take(3)
        .toList();

    Widget section(ServiceSectionEntries value) => ServicesSection(
      section: value,
      editMode: _editing,
      isFavorite: (entry) => _favorites.contains(entry.id),
      onOpen: _open,
      onToggleFavorite: _toggleFavorite,
    );

    return PreviewPage(
      children: [
        AppScreenHeader(
          title: l10n.services,
          padding: EdgeInsets.zero,
          textAction: AppHeaderTextAction(
            onTap: () => setState(() => _editing = !_editing),
            label: _editing ? l10n.servicesEditDone : l10n.servicesConfigure,
          ),
        ),
        AnimatedSize(
          duration: NinjaMotion.of(context),
          curve: NinjaMotion.enter,
          child: _searching
              ? Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        controller: _query,
                        hintText: l10n.servicesSearchPlaceholder,
                        onChanged: (value) =>
                            setState(() => _queryText = value),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    AppIconButton(
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).closeButtonTooltip,
                      icon: const AppLineIconWidget(AppLineIcon.close),
                      onPressed: () => setState(() {
                        _query.clear();
                        _queryText = '';
                        _searching = false;
                        FocusScope.of(context).unfocus();
                      }),
                    ),
                  ],
                )
              : AppSearchBar.button(
                  hintText: l10n.servicesSearchPlaceholder,
                  isOnCanvas: true,
                  trailingIcon: null,
                  onTap: () => setState(() => _searching = true),
                ),
        ),
        if (_editing) AppBanner(message: l10n.servicesEditBanner),
        if (selected == null) ...[
          if (_matches(feature))
            ServicesFeatureCard(
              entry: feature,
              onTap: () => _open(feature),
              onToggleFavorite: () => _toggleFavorite(feature),
              editMode: _editing,
              favorite: _favorites.contains(feature.id),
            ),
          if (spotlight.any(_matches))
            section(
              ServiceSectionEntries(
                key: pinned.isEmpty ? 'quick' : 'pinned',
                title: pinned.isEmpty
                    ? l10n.servicesSectionImportant
                    : l10n.servicesSectionPinned,
                entries: spotlight.where(_matches).toList(),
              ),
            ),
        ],
        PreviewPageRail(
          child: AppChipRow<String?>(
            key: const ValueKey('preview-services-categories'),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            value: selected?.key,
            style: AppChipStyle.tinted,
            spacing: AppSpacing.sm,
            onChanged: (value) => setState(() => _sectionKey = value),
            items: [
              AppChipRowItem(
                key: const ValueKey('preview-services-category-all'),
                value: null,
                label: l10n.servicesSectionAll,
              ),
              for (final value in sections)
                AppChipRowItem(
                  key: ValueKey('preview-services-category-${value.key}'),
                  value: value.key,
                  label: value.title,
                ),
            ],
          ),
        ),
        if (catalog.entries.isNotEmpty) section(catalog),
        AppSectionTitle(title: l10n.miniAppsTitle),
        if (apps.isEmpty)
          AppEmptyState.compact(title: l10n.miniAppsNothingFound)
        else
          for (final app in apps)
            MiniAppCard(
              app: app,
              onTap: () => unawaited(_showAppInfo(app)),
            ),
      ],
    );
  }
}
