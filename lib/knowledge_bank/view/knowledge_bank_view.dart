import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/knowledge_bank/cubit/knowledge_bank_cubit.dart';
import 'package:rtu_mirea_app/knowledge_bank/view/knowledge_bank_list.dart';
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

  Future<void> _upload(
    BuildContext context,
    Future<void> Function() materialUploaded,
  ) async {
    final l10n = context.l10n;
    final created = await showAppSheet<bool>(
      context,
      title: l10n.knowledgeUploadTitle,
      subtitle: l10n.knowledgeUploadSubtitle,
      backgroundColor: context.ninja.canvas,
      child: MaterialUploadSheet(repository: context.read()),
    );
    if (created == true) await materialUploaded();
  }

  Future<void> _download(
    BuildContext context,
    KnowledgeBankCubit cubit,
    StudyMaterial material,
  ) async {
    if (_openingMaterialIds.contains(material.id)) return;
    setState(() => _openingMaterialIds.add(material.id));
    try {
      final uri = await cubit.materialUrl(material);
      if (uri == null) throw const FormatException('Material URL unavailable');
      final opened = await widget.onOpenMaterial(uri);
      if (!opened) throw StateError('No application can open the material');
      if (!mounted) return;
      await cubit.materialOpened(material);
    } on Exception catch (_) {
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
    final colors = context.ninja;
    final l10n = context.l10n;
    final state = context.watch<KnowledgeBankCubit>().state;
    final cubit = context.read<KnowledgeBankCubit>();
    final isLoading = state.status == .loading && state.materials.isEmpty;
    final isFailure = state.status == .failure && state.materials.isEmpty;

    return Scaffold(
      backgroundColor: colors.canvas,
      floatingActionButton: AppFab.extended(
        icon: AppLineIcon.plus,
        label: l10n.knowledgeUpload,
        onPressed: () => unawaited(_upload(context, cubit.materialUploaded)),
      ),
      body: NinjaSkeletonGroup(
        excludeSemantics: false,
        pulse: isLoading,
        child: SafeArea(
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  NinjaMetrics.screenPadding,
                  14,
                  NinjaMetrics.screenPadding,
                  18,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.knowledgeTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: NinjaText.display.copyWith(
                                color: colors.ink,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          NinjaIconButton(
                            key: const ValueKey('knowledge-refresh-button'),
                            icon: const AppLineIconWidget(
                              AppLineIcon.refresh,
                              size: 20,
                            ),
                            tooltip: l10n.refreshData,
                            onPressed: isLoading
                                ? null
                                : () => unawaited(cubit.load()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (isLoading)
                        const NinjaSkeleton.bar(widthFactor: .48, height: 14)
                      else
                        Text(
                          l10n.knowledgeSubtitle(state.materials.length),
                          style: NinjaText.body.copyWith(color: colors.muted),
                        ),
                      if (!isFailure) ...[
                        const SizedBox(height: 16),
                        KnowledgeBalanceCard(
                          profile: state.profile,
                          loading: isLoading,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (!isFailure)
                SliverToBoxAdapter(
                  child: _KnowledgeFilters(
                    value: state.type,
                    onChanged: cubit.typeChanged,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 14)),
            ],
            body: RefreshIndicator(
              color: colors.brand,
              backgroundColor: colors.surface,
              onRefresh: cubit.load,
              child: KnowledgeBankList(
                isLoading: isLoading,
                isFailure: isFailure,
                isFiltered: state.type != 'all' && state.materials.isNotEmpty,
                materials: state.filteredMaterials,
                authors: state.authors,
                openingMaterialIds: _openingMaterialIds,
                onDownload: (material) =>
                    unawaited(_download(context, cubit, material)),
                onRetry: () => unawaited(cubit.load()),
                onUpload: () =>
                    unawaited(_upload(context, cubit.materialUploaded)),
                onResetFilter: () => cubit.typeChanged('all'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
