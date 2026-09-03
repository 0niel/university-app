import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/widgets/widgets.dart';
import 'package:rtu_mirea_app/knowledge_bank/config/knowledge_material_types.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MaterialRow extends StatelessWidget {
  const MaterialRow({
    required this.material,
    required this.onDownload,
    this.loading = false,
    super.key,
  });

  final StudyMaterial material;
  final VoidCallback onDownload;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final typeLabel = KnowledgeMaterialTypes.labelOf(
      l10n,
      material.materialType,
    );
    final meta = [
      typeLabel,
      if (material.authorName.isNotEmpty) material.authorName,
      if (material.pages > 0) l10n.knowledgePages(material.pages),
    ].join(' · ');
    final accent = colors.lecture;
    final compact = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    final price = switch ((material.hasFile, material.requiresRepublish)) {
      (false, true) => PricePill(
        text: l10n.knowledgeMaterialRepublishRequired,
        locked: true,
      ),
      (false, false) => PricePill(
        text: l10n.knowledgeMaterialNoAttachment,
        locked: true,
      ),
      (true, _) when material.isFree => const PricePill(free: true),
      _ => PricePill(shurikens: material.price),
    };
    final action = loading
        ? const NinjaSpinner(size: 24)
        : material.hasFile && material.isFree
        ? Tooltip(
            message: l10n.knowledgeDownload,
            child: AppLineIconWidget(
              AppLineIcon.download,
              size: 16,
              color: colors.muted2,
            ),
          )
        : price;
    final enabled = material.hasFile && !loading;

    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: [
        material.title,
        meta,
        if (!material.hasFile)
          material.requiresRepublish
              ? l10n.knowledgeMaterialRepublishRequired
              : l10n.knowledgeMaterialNoAttachment,
      ].join(', '),
      child: AppPressable(
        onTap: enabled ? onDownload : null,
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.tintOf(accent),
                  borderRadius: BorderRadius.circular(AppRadius.tile),
                ),
                child: SizedBox.square(
                  dimension: 44,
                  child: Center(
                    child: AppLineIconWidget(
                      AppLineIcon.book,
                      size: 20,
                      color: accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (material.subjects.isNotEmpty) ...[
                      Text(
                        material.subjects.join(' · '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.sans(11.5, FontWeight.w600).copyWith(
                          color: colors.muted,
                        ),
                      ),
                      const SizedBox(height: 3),
                    ],
                    Text(
                      material.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.sans(
                        14.5,
                        FontWeight.w600,
                      ).copyWith(color: colors.ink),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      meta,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.sans(12, FontWeight.w400).copyWith(
                        color: colors.muted,
                      ),
                    ),
                    if (compact) ...[
                      const SizedBox(height: AppSpacing.gap),
                      Align(alignment: Alignment.centerLeft, child: action),
                    ],
                  ],
                ),
              ),
              if (!compact) ...[
                const SizedBox(width: AppSpacing.md),
                action,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
