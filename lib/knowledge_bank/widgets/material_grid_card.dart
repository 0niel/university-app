import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/community/widgets/widgets.dart';
import 'package:rtu_mirea_app/knowledge_bank/config/knowledge_material_types.dart';
import 'package:rtu_mirea_app/knowledge_bank/widgets/material_thumbnail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MaterialGridCard extends StatelessWidget {
  const MaterialGridCard({
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
  final String? previewUrl;
  final Object? heroTag;
  final VoidCallback onOpen;
  final VoidCallback onDownload;
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
    final createdAt = material.createdAt;
    final meta = [
      material.authorName,
      if (createdAt != null)
        DateFormat('d MMM', l10n.localeName).format(createdAt),
    ].join(' · ');
    final enabled = material.hasFile && !loading;

    return AppCard(
      onTap: enabled ? onOpen : null,
      onLongPress: onLongPress,
      padding: EdgeInsets.zero,
      semanticsLabel: material.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: MaterialThumbnail(
              heroTag: heroTag,
              previewUrl: previewUrl,
              mimeType: material.mimeType,
              iconSize: 28,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.card),
              ),
              accent: colors.lecture,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: AppSpacing.xsm,
                  runSpacing: AppSpacing.xsm,
                  children: [
                    if (material.subjects.isNotEmpty)
                      AppTag(label: material.subjects.first),
                    AppTag(label: typeLabel, tone: .accent),
                  ],
                ),
                const SizedBox(height: AppSpacing.xsm),
                Text(
                  material.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.headline.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  meta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.captionSmall.copyWith(color: colors.muted),
                ),
                const SizedBox(height: AppSpacing.sm),
                PricePill(
                  free: material.hasFile && material.isFree,
                  shurikens: material.hasFile && !material.isFree
                      ? material.price
                      : null,
                  locked: !material.hasFile,
                  text: material.hasFile
                      ? null
                      : material.requiresRepublish
                      ? l10n.knowledgeMaterialRepublishRequired
                      : l10n.knowledgeMaterialNoAttachment,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    if (onLike != null)
                      AppIconButton(
                        icon: AppLineIconWidget(
                          AppLineIcon.heart,
                          color: material.isLiked
                              ? colors.danger
                              : colors.muted2,
                        ),
                        size: AppIconButtonSize.small,
                        tone: .plain,
                        tooltip: l10n.knowledgeLike,
                        onPressed: onLike,
                      ),
                    if (material.likes > 0) ...[
                      const SizedBox(width: AppSpacing.xxs),
                      Text(
                        '${material.likes}',
                        style: AppText.tabular(
                          AppText.captionSmall.copyWith(color: colors.muted),
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (loading)
                      const NinjaSpinner(size: 24)
                    else
                      AppIconButton(
                        icon: AppLineIconWidget(
                          AppLineIcon.download,
                          color: enabled ? colors.ink : colors.muted2,
                        ),
                        size: AppIconButtonSize.small,
                        tone: .plain,
                        tooltip: l10n.knowledgeDownload,
                        onPressed: enabled ? onDownload : null,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
