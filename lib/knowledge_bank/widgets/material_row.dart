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
    final colors = context.ninja;
    final l10n = context.l10n;
    final typeLabel = KnowledgeMaterialTypes.labelOf(
      l10n,
      material.materialType,
    );
    final meta = [
      typeLabel,
      if (material.subjectName.isNotEmpty) material.subjectName,
      material.authorName,
    ].join(' · ');
    final accent = colors.brand;
    final compact = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    final price = material.isFree
        ? const PricePill(free: true)
        : PricePill(shurikens: material.price);
    final action = loading
        ? SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: accent,
            ),
          )
        : price;
    final enabled = material.hasFile && !loading;

    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: '${material.title}, $meta',
      child: AppPressable(
        onTap: enabled ? onDownload : null,
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(NinjaRadius.card),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(NinjaRadius.button),
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
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      material.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: NinjaText.headline.copyWith(color: colors.ink),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      meta,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: NinjaText.subtext.copyWith(color: colors.muted),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      [
                        '${material.downloads}',
                        if (material.pages > 0)
                          l10n.knowledgePages(material.pages),
                      ].join(' · '),
                      style: NinjaText.helper.copyWith(
                        color: colors.muted,
                      ),
                    ),
                    if (compact) ...[
                      const SizedBox(height: 10),
                      Align(alignment: Alignment.centerLeft, child: action),
                    ],
                  ],
                ),
              ),
              if (!compact) ...[
                const SizedBox(width: 12),
                action,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
