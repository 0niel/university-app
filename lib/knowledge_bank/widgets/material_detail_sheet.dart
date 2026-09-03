import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/knowledge_bank/config/knowledge_material_types.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:share_plus/share_plus.dart';

Future<void> showMaterialDetailSheet(
  BuildContext context, {
  required StudyMaterial material,
  required Future<void> Function() onOpen,
  required Future<void> Function() onDownload,
  required Future<String?> Function() resolveShareUrl,
  required Future<void> Function() onDelete,
}) async {
  final l10n = context.l10n;
  final action = await showAppSheet<String>(
    context,
    title: l10n.knowledgeMaterialDetailTitle,
    child: _MaterialDetailContent(material: material),
  );
  if (!context.mounted || action == null) return;
  switch (action) {
    case 'open':
      await onOpen();
    case 'download':
      await onDownload();
    case 'share':
      final url = await resolveShareUrl();
      if (url == null) return;
      await SharePlus.instance.share(
        ShareParams(uri: Uri.tryParse(url), subject: material.title),
      );
    case 'delete':
      if (!context.mounted) return;
      final confirmed = await showAppConfirmDialog(
        context,
        title: l10n.knowledgeMaterialDelete,
        message: l10n.knowledgeMaterialDeleteConfirm,
        confirmLabel: l10n.knowledgeMaterialDelete,
        cancelLabel: l10n.cancel,
        destructive: true,
      );
      if (!confirmed) return;
      try {
        await onDelete();
        if (context.mounted) {
          showNinjaToast(context, message: l10n.knowledgeMaterialDeleted);
        }
      } on Object {
        if (context.mounted) {
          showNinjaToast(
            context,
            showCheck: false,
            message: l10n.knowledgeMaterialDeleteFailed,
          );
        }
      }
  }
}

class _MaterialDetailContent extends StatelessWidget {
  const _MaterialDetailContent({required this.material});

  final StudyMaterial material;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final createdAt = material.createdAt;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          material.title,
          style: AppText.title.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.xsm,
          runSpacing: AppSpacing.xsm,
          children: [
            for (final subject in material.subjects) AppTag(label: subject),
            AppTag(
              label: KnowledgeMaterialTypes.labelOf(
                l10n,
                material.materialType,
              ),
              tone: .accent,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _MetaRow(
          icon: AppLineIcon.user,
          label: l10n.knowledgeMaterialAuthor,
          value: material.authorName,
        ),
        if (createdAt != null)
          _MetaRow(
            icon: AppLineIcon.calendar,
            label: l10n.knowledgeMaterialDate,
            value: DateFormat('d MMMM yyyy', l10n.localeName).format(
              createdAt,
            ),
          ),
        _MetaRow(
          icon: AppLineIcon.folder,
          label: l10n.knowledgeMaterialSize,
          value: material.fileSize <= 0
              ? l10n.knowledgeMaterialNoAttachment
              : l10n.knowledgeUploadFileSize(
                  (material.fileSize / 1024 / 1024).toStringAsFixed(1),
                ),
        ),
        _MetaRow(
          icon: AppLineIcon.download,
          label: l10n.knowledgeDownload,
          value: '${material.downloads}',
        ),
        _MetaRow(
          icon: AppLineIcon.heart,
          label: l10n.knowledgeLike,
          value: '${material.likes}',
        ),
        const SizedBox(height: AppSpacing.lg),
        AppListGroup(
          children: [
            AppListRow(
              leading: const AppIconTile(icon: AppLineIcon.external),
              title: l10n.open,
              isFirst: true,
              onTap: material.hasFile
                  ? () => Navigator.of(context).pop('open')
                  : null,
            ),
            AppListRow(
              leading: const AppIconTile(icon: AppLineIcon.download),
              title: l10n.knowledgeDownload,
              onTap: material.hasFile
                  ? () => Navigator.of(context).pop('download')
                  : null,
            ),
            AppListRow(
              leading: const AppIconTile(icon: AppLineIcon.share),
              title: l10n.knowledgeMaterialShareLink,
              onTap: material.hasFile
                  ? () => Navigator.of(context).pop('share')
                  : null,
            ),
            if (material.isMine)
              AppListRow(
                leading: const AppIconTile(icon: AppLineIcon.trash),
                title: l10n.knowledgeMaterialDelete,
                destructive: true,
                onTap: () => Navigator.of(context).pop('delete'),
              ),
          ],
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final AppLineIcon icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        children: [
          AppLineIconWidget(icon, size: 16, color: colors.muted),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: AppText.subtext.copyWith(color: colors.muted),
            ),
          ),
          Text(
            value,
            style: AppText.subtext.copyWith(
              color: colors.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
