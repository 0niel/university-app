import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/knowledge_bank/cubit/knowledge_bank_cubit.dart';
import 'package:rtu_mirea_app/knowledge_bank/utils/material_search.dart';
import 'package:rtu_mirea_app/knowledge_bank/view/knowledge_bank_list.dart';
import 'package:rtu_mirea_app/knowledge_bank/widgets/material_subject_picker.dart';
import 'package:rtu_mirea_app/knowledge_bank/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

part 'knowledge_filters.dart';

const _kGridViewPrefKey = 'knowledge_bank_grid_view';

class KnowledgeBankView extends StatefulWidget {
  const KnowledgeBankView({
    this.onOpenMaterial = _openExternal,
    super.key,
  });

  final Future<bool> Function(Uri uri) onOpenMaterial;

  static Future<bool> _openExternal(Uri uri) =>
      launchUrl(uri, mode: .externalApplication);

  @override
  State<KnowledgeBankView> createState() => _KnowledgeBankViewState();
}

class _KnowledgeBankViewState extends State<KnowledgeBankView> {
  final Set<String> _openingMaterialIds = {};
  final _searchController = TextEditingController();
  String _query = '';
  Set<String> _subjects = {};
  String _sort = 'popular';
  bool _gridView = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadViewMode());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadViewMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final grid = prefs.getBool(_kGridViewPrefKey);
      if (mounted && grid != null) setState(() => _gridView = grid);
    } on Exception {
      return;
    }
  }

  Future<void> _setGridView(bool grid) async {
    setState(() => _gridView = grid);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kGridViewPrefKey, grid);
    } on Exception {
      return;
    }
  }

  Future<void> _upload(
    BuildContext context,
    Future<void> Function() materialUploaded,
  ) async {
    final l10n = context.l10n;
    final created = await showAppSheet<bool>(
      context,
      title: l10n.knowledgeUploadTitle,
      subtitle: l10n.knowledgeUploadSubtitle,
      backgroundColor: context.colors.canvas,
      child: MaterialBatchUploadSheet(
        repository: context.read(),
        initialSubjects: _knownSubjects(),
      ),
    );
    if (created == true) {
      if (context.mounted) {
        showNinjaToast(context, message: l10n.knowledgeUploadSuccess);
      }
      await materialUploaded();
    }
  }

  List<String> _knownSubjects() => {
    for (final material in context.read<KnowledgeBankCubit>().state.materials)
      ...material.subjects,
  }.toList()..sort();

  List<String> _popularSubjects(List<StudyMaterial> materials) {
    final counts = <String, int>{};
    for (final material in materials) {
      for (final subject in material.subjects) {
        counts[subject] = (counts[subject] ?? 0) + 1;
      }
    }
    final subjects = counts.keys.toList()
      ..sort((a, b) => counts[b]!.compareTo(counts[a]!));
    return subjects.take(8).toList();
  }

  Future<void> _chooseSubjects() async {
    final selected = await showMaterialSubjectPicker(
      context,
      repository: context.read(),
      selected: _subjects,
      initialSubjects: _knownSubjects(),
    );
    if (!mounted || selected == null) return;
    setState(() => _subjects = selected);
  }

  void _toggleQuickSubject(String subject) {
    setState(() {
      if (!_subjects.remove(subject)) _subjects.add(subject);
    });
  }

  Future<Uri?> _resolveAccess(
    BuildContext context,
    KnowledgeBankCubit cubit,
    StudyMaterial material,
  ) async {
    final access = await cubit.materialAccess(material);
    if (!context.mounted) return null;
    if (!access.canDownload) {
      if (access.price <= 0) {
        throw const MaterialPurchaseException(.unavailable);
      }
      var confirmationSubmitted = false;
      void finishConfirmation({required bool confirmed}) {
        if (confirmationSubmitted) return;
        confirmationSubmitted = true;
        Navigator.of(context, rootNavigator: true).pop(confirmed);
      }

      final confirmed = await showAppSheet<bool>(
        context,
        title: context.l10n.knowledgePurchaseTitle,
        subtitle: context.l10n.knowledgePurchaseBody(
          material.title,
          context.l10n.knowledgePriceShurikens(access.price),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton.primary(
              label: context.l10n.knowledgePurchaseConfirm,
              onPressed: () => finishConfirmation(confirmed: true),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton.secondary(
              label: context.l10n.cancel,
              onPressed: () => finishConfirmation(confirmed: false),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return null;
      await cubit.purchaseMaterial(material, expectedPrice: access.price);
      if (!mounted) return null;
    }
    final uri = await cubit.materialUrl(material);
    if (uri == null) throw const FormatException('Material URL unavailable');
    return uri;
  }

  Future<void> _download(
    BuildContext context,
    KnowledgeBankCubit cubit,
    StudyMaterial material,
  ) async {
    if (_openingMaterialIds.contains(material.id)) return;
    setState(() => _openingMaterialIds.add(material.id));
    try {
      final uri = await _resolveAccess(context, cubit, material);
      if (uri == null || !context.mounted) return;
      final opened = await widget.onOpenMaterial(uri);
      if (!opened) throw StateError('No application can open the material');
      if (!mounted) return;
      await cubit.materialOpened(material);
    } on MaterialPurchaseException catch (error) {
      if (!context.mounted) return;
      _showPurchaseError(context, error);
    } on Object catch (_) {
      if (!context.mounted) return;
      _showOpenFailed(context);
    } finally {
      if (mounted) setState(() => _openingMaterialIds.remove(material.id));
    }
  }

  Future<void> _openMaterial(
    BuildContext context,
    KnowledgeBankCubit cubit,
    StudyMaterial material,
  ) async {
    if (_openingMaterialIds.contains(material.id)) return;
    setState(() => _openingMaterialIds.add(material.id));
    try {
      final uri = await _resolveAccess(context, cubit, material);
      if (uri == null || !context.mounted) return;
      unawaited(cubit.materialOpened(material));
      await showMediaViewer(
        context,
        items: [
          MediaItem(
            url: uri.toString(),
            kind: MediaItem.kindOf(
              mimeType: material.mimeType,
              fileName: material.fileName,
            ),
            title: material.title,
            fileName: material.fileName,
            mimeType: material.mimeType,
            sizeBytes: material.fileSize,
          ),
        ],
      );
    } on MaterialPurchaseException catch (error) {
      if (!context.mounted) return;
      _showPurchaseError(context, error);
    } on Object catch (_) {
      if (!context.mounted) return;
      _showOpenFailed(context);
    } finally {
      if (mounted) setState(() => _openingMaterialIds.remove(material.id));
    }
  }

  void _showPurchaseError(
    BuildContext context,
    MaterialPurchaseException error,
  ) {
    final l10n = context.l10n;
    showNinjaToast(
      context,
      showCheck: false,
      message: switch (error.reason) {
        .insufficientBalance => l10n.knowledgePurchaseInsufficient,
        .priceChanged => l10n.knowledgePurchasePriceChanged,
        .unavailable => l10n.knowledgePurchaseFailed,
      },
    );
  }

  void _showOpenFailed(BuildContext context) {
    if (!context.mounted) return;
    NinjaToastHost.maybeOf(context)?.show(
      NinjaToastData(
        message: context.l10n.lessonDetailsOpenFailed,
        showCheck: false,
      ),
    );
  }

  Future<void> _toggleLike(
    BuildContext context,
    KnowledgeBankCubit cubit,
    StudyMaterial material,
  ) async {
    try {
      await cubit.toggleLike(material);
    } on Object catch (_) {
      if (!context.mounted) return;
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.lessonDetailsOpenFailed,
      );
    }
  }

  Future<void> _showDetail(
    BuildContext context,
    KnowledgeBankCubit cubit,
    StudyMaterial material,
  ) => showMaterialDetailSheet(
    context,
    material: material,
    onOpen: () => _openMaterial(context, cubit, material),
    onDownload: () => _download(context, cubit, material),
    resolveShareUrl: () async {
      try {
        final uri = await _resolveAccess(context, cubit, material);
        return uri?.toString();
      } on Object {
        if (context.mounted) _showOpenFailed(context);
        return null;
      }
    },
    onDelete: () => cubit.deleteMaterial(material),
  );

  List<StudyMaterial> _sorted(List<StudyMaterial> materials) {
    final sorted = [...materials];
    if (_sort == 'new') {
      sorted.sort((a, b) {
        final left = a.createdAt;
        final right = b.createdAt;
        if (left == null || right == null) return 0;
        return right.compareTo(left);
      });
    } else {
      sorted.sort((a, b) => b.downloads.compareTo(a.downloads));
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final state = context.watch<KnowledgeBankCubit>().state;
    final cubit = context.read<KnowledgeBankCubit>();
    final isLoading = state.status == .loading && state.materials.isEmpty;
    final isFailure = state.status == .failure && state.materials.isEmpty;

    final query = normalizeMaterialSearch(_query);
    final materials = state.filteredMaterials
        .where(
          (material) =>
              (_subjects.isEmpty ||
                  material.subjects.any(
                    (subject) => _subjects.any(
                      (selected) =>
                          normalizeMaterialSearch(selected) ==
                          normalizeMaterialSearch(subject),
                    ),
                  )) &&
              (query.isEmpty ||
                  [
                    material.title,
                    ...material.subjects,
                    material.authorName,
                  ].any(
                    (value) => normalizeMaterialSearch(value).contains(query),
                  )),
        )
        .toList(growable: false);
    final sortedMaterials = _sorted(materials);
    final quickSubjects = _popularSubjects(state.materials);
    return Scaffold(
      backgroundColor: colors.canvas,
      body: Column(
        children: [
          AppInnerHeader(
            title: l10n.knowledgeTitle,
            onBack: () => Navigator.of(context).maybePop(),
            backSemanticsLabel: l10n.back,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.screen,
              AppSpacing.screen,
              AppSpacing.md,
            ),
            child: AppSearchBar(
              controller: _searchController,
              hintText: l10n.knowledgeSearchHint,
              onCanvas: true,
              trailingIcon: null,
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          SizedBox(
            height: AppControlSize.iconButton,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              children: [
                AppChip.filter(
                  label: l10n.knowledgeSubjectsFilter,
                  leadingIcon: AppLineIcon.filter,
                  count: _subjects.isEmpty ? null : _subjects.length,
                  selected: _subjects.isNotEmpty,
                  onTap: () => unawaited(_chooseSubjects()),
                ),
                for (final subject in quickSubjects) ...[
                  const SizedBox(width: AppSpacing.xsm),
                  AppChip.filter(
                    label: subject,
                    selected: _subjects.contains(subject),
                    onTap: () => _toggleQuickSubject(subject),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: _KnowledgeFilters(
              value: state.type,
              onChanged: cubit.typeChanged,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: Row(
              children: [
                Expanded(
                  child: AppChipRow<String>(
                    value: _sort,
                    onChanged: (value) => setState(() => _sort = value),
                    items: [
                      AppChipRowItem(
                        value: 'popular',
                        label: l10n.knowledgeSortPopular,
                      ),
                      AppChipRowItem(
                        value: 'new',
                        label: l10n.knowledgeSortNew,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppIconButton(
                  icon: const AppLineIconWidget(AppLineIcon.clipboard),
                  tone: _gridView ? .secondary : .tonal,
                  size: .compact,
                  tooltip: l10n.knowledgeViewList,
                  onPressed: () => unawaited(_setGridView(false)),
                ),
                const SizedBox(width: AppSpacing.xsm),
                AppIconButton(
                  icon: const AppLineIconWidget(AppLineIcon.grid),
                  tone: _gridView ? .tonal : .secondary,
                  size: .compact,
                  tooltip: l10n.knowledgeViewGrid,
                  onPressed: () => unawaited(_setGridView(true)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Expanded(
            child: RefreshIndicator(
              color: colors.accent,
              backgroundColor: colors.surface,
              onRefresh: cubit.load,
              child: KnowledgeBankList(
                isLoading: isLoading,
                isFailure: isFailure,
                isFiltered:
                    query.isNotEmpty ||
                    state.type != 'all' ||
                    _subjects.isNotEmpty,
                materials: sortedMaterials,
                authors: state.authors,
                previewUrls: state.previewUrls,
                gridView: _gridView,
                onLike: (material) =>
                    unawaited(_toggleLike(context, cubit, material)),
                onLongPress: (material) =>
                    unawaited(_showDetail(context, cubit, material)),
                footer: AppButton.secondary(
                  label: l10n.knowledgeUpload,
                  onPressed: () =>
                      unawaited(_upload(context, cubit.materialUploaded)),
                ),
                openingMaterialIds: _openingMaterialIds,
                onOpen: (material) =>
                    unawaited(_openMaterial(context, cubit, material)),
                onDownload: (material) =>
                    unawaited(_download(context, cubit, material)),
                onRetry: () => unawaited(cubit.load()),
                onUpload: () =>
                    unawaited(_upload(context, cubit.materialUploaded)),
                onResetFilter: () {
                  _searchController.clear();
                  setState(() {
                    _query = '';
                    _subjects.clear();
                  });
                  cubit.typeChanged('all');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
