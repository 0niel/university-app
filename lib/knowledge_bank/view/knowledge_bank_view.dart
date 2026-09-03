import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/knowledge_bank/cubit/knowledge_bank_cubit.dart';
import 'package:rtu_mirea_app/knowledge_bank/utils/material_search.dart';
import 'package:rtu_mirea_app/knowledge_bank/view/knowledge_bank_list.dart';
import 'package:rtu_mirea_app/knowledge_bank/widgets/material_subject_picker.dart';
import 'package:rtu_mirea_app/knowledge_bank/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

part 'knowledge_filters.dart';

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      child: MaterialUploadSheet(
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

  Future<void> _download(
    BuildContext context,
    KnowledgeBankCubit cubit,
    StudyMaterial material,
  ) async {
    if (_openingMaterialIds.contains(material.id)) return;
    setState(() => _openingMaterialIds.add(material.id));
    try {
      final access = await cubit.materialAccess(material);
      if (!context.mounted) return;
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
        if (confirmed != true || !mounted) return;
        await cubit.purchaseMaterial(material, expectedPrice: access.price);
        if (!mounted) return;
      }
      final uri = await cubit.materialUrl(material);
      if (uri == null) throw const FormatException('Material URL unavailable');
      final opened = await widget.onOpenMaterial(uri);
      if (!opened) throw StateError('No application can open the material');
      if (!mounted) return;
      await cubit.materialOpened(material);
    } on MaterialPurchaseException catch (error) {
      if (!context.mounted) return;
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
    } on Object catch (_) {
      if (!context.mounted) return;
      NinjaToastHost.maybeOf(context)?.show(
        NinjaToastData(
          message: context.l10n.lessonDetailsOpenFailed,
          showCheck: false,
        ),
      );
    } finally {
      if (mounted) setState(() => _openingMaterialIds.remove(material.id));
    }
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
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              0,
              AppSpacing.screen,
              AppSpacing.sectionGap,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: AppSpacing.sm,
                children: [
                  AppChip(
                    label: l10n.knowledgeSubjectsFilter,
                    leadingIcon: AppLineIcon.filter,
                    selected: _subjects.isNotEmpty,
                    onTap: () => unawaited(_chooseSubjects()),
                  ),
                  for (final subject in _subjects)
                    AppChip(
                      label: subject,
                      selected: true,
                      onRemove: () => setState(() => _subjects.remove(subject)),
                    ),
                ],
              ),
            ),
          ),
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
                materials: materials,
                authors: state.authors,
                footer: Column(
                  children: [
                    _KnowledgeFilters(
                      value: state.type,
                      onChanged: cubit.typeChanged,
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    AppButton.secondary(
                      label: l10n.knowledgeUpload,
                      onPressed: () =>
                          unawaited(_upload(context, cubit.materialUploaded)),
                    ),
                  ],
                ),
                openingMaterialIds: _openingMaterialIds,
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
