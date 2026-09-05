import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/widgets/widgets.dart';
import 'package:rtu_mirea_app/knowledge_bank/config/knowledge_material_types.dart';
import 'package:rtu_mirea_app/knowledge_bank/widgets/material_thumbnail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MaterialRow extends StatelessWidget {
  const MaterialRow({
    required this.material,
    required this.onOpen,
    required this.onDownload,
    this.previewUrl,
    this.heroTag,
    this.onLike,
    this.onLongPress,
    this.loading = false,
    super.key,
  });

  final StudyMaterial material;
  final VoidCallback onOpen;
  final VoidCallback onDownload;
  final String? previewUrl;
  final Object? heroTag;
  final VoidCallback? onLike;
  final VoidCallback? onLongPress;
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
    final enabled = material.hasFile && !loading;
    final action = loading
        ? const NinjaSpinner(size: 24)
        : AppPressable(
            onTap: enabled ? onDownload : null,
            semanticsLabel: l10n.knowledgeDownload,
            child: material.hasFile && material.isFree
                ? AppLineIconWidget(
                    AppLineIcon.download,
                    size: 16,
                    color: colors.muted2,
                  )
                : price,
          );

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
        onTap: enabled ? onOpen : null,
        onLongPress: onLongPress,
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
              SizedBox(
                width: 56,
                height: 56,
                child: MaterialThumbnail(
                  heroTag: heroTag,
                  previewUrl: previewUrl,
                  mimeType: material.mimeType,
                  accent: accent,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            meta,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.sans(12, FontWeight.w400).copyWith(
                              color: colors.muted,
                            ),
                          ),
                        ),
                        if (onLike != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          AppPressable(
                            onTap: onLike,
                            semanticsLabel: l10n.knowledgeLike,
                            semanticsSelected: material.isLiked,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppLineIconWidget(
                                  AppLineIcon.heart,
                                  size: 14,
                                  color: material.isLiked
                                      ? colors.danger
                                      : colors.muted2,
                                ),
                                if (material.likes > 0) ...[
                                  const SizedBox(width: 3),
                                  Text(
                                    '${material.likes}',
                                    style: AppText.tabular(
                                      AppText.sans(
                                        11,
                                        FontWeight.w600,
                                      ).copyWith(color: colors.muted),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
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
