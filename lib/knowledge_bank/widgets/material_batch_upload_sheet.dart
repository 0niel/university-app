import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:rtu_mirea_app/knowledge_bank/config/knowledge_material_types.dart';
import 'package:rtu_mirea_app/knowledge_bank/utils/image_preview.dart';
import 'package:rtu_mirea_app/knowledge_bank/widgets/material_subject_picker.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:uuid/uuid.dart';

const int _kMaxUploadBytes = 100 * 1024 * 1024;

enum _BatchStatus { pending, uploading, done, failed }

class _BatchEntry {
  _BatchEntry({
    required this.id,
    required this.fileName,
    required this.bytes,
    required this.mimeType,
    required String title,
  }) : titleController = TextEditingController(text: title);

  final String id;
  final String fileName;
  final Uint8List bytes;
  final String? mimeType;
  final TextEditingController titleController;
  Uint8List? previewBytes;
  int? previewWidth;
  int? previewHeight;
  _BatchStatus status = _BatchStatus.pending;

  void dispose() => titleController.dispose();
}

typedef BatchFilesPicker = Future<FilePickerResult?> Function();

class MaterialBatchUploadSheet extends StatefulWidget {
  const MaterialBatchUploadSheet({
    required this.repository,
    super.key,
    this.initialSubjects = const [],
    this.filesPickerBuilder,
  });

  final CampusRepository repository;
  final List<String> initialSubjects;
  final BatchFilesPicker? filesPickerBuilder;

  @override
  State<MaterialBatchUploadSheet> createState() =>
      _MaterialBatchUploadSheetState();
}

class _MaterialBatchUploadSheetState extends State<MaterialBatchUploadSheet> {
  final _picker = ImagePicker();
  final String _batchId = const Uuid().v4();
  final List<_BatchEntry> _entries = [];
  Set<String> _subjects = {};
  String _type = 'note';
  bool _anonymous = false;
  bool _picking = false;
  bool _uploading = false;

  @override
  void dispose() {
    for (final entry in _entries) {
      entry.dispose();
    }
    super.dispose();
  }

  String _titleFromFileName(String fileName) {
    final extensionIndex = fileName.lastIndexOf('.');
    return extensionIndex > 0
        ? fileName.substring(0, extensionIndex)
        : fileName;
  }

  Future<void> _addEntry({
    required String fileName,
    required Uint8List bytes,
  }) async {
    if (bytes.isEmpty || bytes.length > _kMaxUploadBytes) return;
    final mimeType = lookupMimeType(fileName, headerBytes: bytes);
    final entry = _BatchEntry(
      id: const Uuid().v4(),
      fileName: fileName,
      bytes: bytes,
      mimeType: mimeType,
      title: _titleFromFileName(fileName),
    );
    if (mimeType != null && mimeType.startsWith('image/')) {
      final preview = await generateImagePreview(bytes);
      entry
        ..previewBytes = preview?.bytes
        ..previewWidth = preview?.width
        ..previewHeight = preview?.height;
    }
    if (!mounted) {
      entry.dispose();
      return;
    }
    setState(() => _entries.add(entry));
  }

  Future<void> _pickImages() async {
    if (_picking || _uploading) return;
    setState(() => _picking = true);
    try {
      final images = await _picker.pickMultiImage(
        maxWidth: 2000,
        imageQuality: 85,
      );
      for (final image in images) {
        await _addEntry(fileName: image.name, bytes: await image.readAsBytes());
      }
    } on Object catch (error, stackTrace) {
      log('Failed to pick images', error: error, stackTrace: stackTrace);
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _pickCamera() async {
    if (_picking || _uploading) return;
    setState(() => _picking = true);
    try {
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2000,
        imageQuality: 85,
      );
      if (photo != null) {
        await _addEntry(fileName: photo.name, bytes: await photo.readAsBytes());
      }
    } on Object catch (error, stackTrace) {
      log('Failed to capture a photo', error: error, stackTrace: stackTrace);
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _pickFiles() async {
    if (_picking || _uploading) return;
    setState(() => _picking = true);
    try {
      final result =
          await (widget.filesPickerBuilder ?? FilePicker.pickFiles)();
      if (result == null) return;
      for (final file in result.files) {
        if (file.size > _kMaxUploadBytes) continue;
        await _addEntry(fileName: file.name, bytes: await file.readAsBytes());
      }
    } on Object catch (error, stackTrace) {
      log('Failed to pick files', error: error, stackTrace: stackTrace);
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  void _removeEntry(_BatchEntry entry) {
    if (_uploading) return;
    entry.dispose();
    setState(() => _entries.remove(entry));
  }

  Future<void> _chooseSubjects() async {
    final selected = await showMaterialSubjectPicker(
      context,
      repository: widget.repository,
      selected: _subjects,
      initialSubjects: widget.initialSubjects,
    );
    if (!mounted || selected == null) return;
    setState(() => _subjects = selected);
  }

  Future<void> _uploadEntry(_BatchEntry entry) async {
    setState(() => entry.status = _BatchStatus.uploading);
    try {
      await widget.repository.createPublicMaterial(
        title: entry.titleController.text.trim(),
        subjectName: _subjects.first,
        subjectNames: _subjects.toList(growable: false),
        materialType: _type,
        isAnonymous: _anonymous,
        fileName: entry.fileName,
        fileBytes: entry.bytes,
        mimeType: entry.mimeType,
        previewBytes: entry.previewBytes,
        previewMimeType: entry.previewBytes == null ? null : 'image/png',
        width: entry.previewWidth,
        height: entry.previewHeight,
        batchId: _batchId,
      );
      if (mounted) setState(() => entry.status = _BatchStatus.done);
    } on Object catch (error, stackTrace) {
      log(
        'Failed to upload a batch material',
        error: error,
        stackTrace: stackTrace,
      );
      if (mounted) setState(() => entry.status = _BatchStatus.failed);
    }
  }

  Future<void> _uploadAll() async {
    if (_uploading || _entries.isEmpty || _subjects.isEmpty) return;
    setState(() => _uploading = true);
    try {
      for (final entry in _entries) {
        if (!mounted) break;
        if (entry.status == _BatchStatus.done) continue;
        await _uploadEntry(entry);
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _retryEntry(_BatchEntry entry) async {
    if (_uploading ||
        _picking ||
        _subjects.isEmpty ||
        entry.status != _BatchStatus.failed ||
        entry.titleController.text.trim().isEmpty) {
      return;
    }
    setState(() => _uploading = true);
    try {
      await _uploadEntry(entry);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  bool get _allDone =>
      _entries.isNotEmpty &&
      _entries.every((entry) => entry.status == _BatchStatus.done);

  int get _doneCount =>
      _entries.where((entry) => entry.status == _BatchStatus.done).length;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final canUpload =
        !_uploading &&
        !_picking &&
        _entries.isNotEmpty &&
        _subjects.isNotEmpty &&
        _entries.every(
          (entry) => entry.titleController.text.trim().isNotEmpty,
        );

    if (_allDone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(Navigator.of(context).maybePop(true));
      });
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          spacing: AppSpacing.sm,
          children: [
            Expanded(
              child: AppButton.tonal(
                label: l10n.knowledgeBatchAddImages,
                icon: const AppLineIconWidget(AppLineIcon.image, size: 18),
                onPressed: _picking || _uploading
                    ? null
                    : () => unawaited(_pickImages()),
              ),
            ),
            Expanded(
              child: AppButton.tonal(
                label: l10n.knowledgeBatchAddFiles,
                icon: const AppLineIconWidget(AppLineIcon.folder, size: 18),
                onPressed: _picking || _uploading
                    ? null
                    : () => unawaited(_pickFiles()),
              ),
            ),
            AppIconButton(
              icon: const AppLineIconWidget(AppLineIcon.camera),
              tooltip: l10n.knowledgeBatchAddCamera,
              onPressed: _picking || _uploading
                  ? null
                  : () => unawaited(_pickCamera()),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (_entries.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Text(
              l10n.knowledgeBatchEmpty,
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: colors.muted),
            ),
          )
        else
          AppListGroup(
            children: [
              for (final entry in _entries)
                _BatchEntryRow(
                  key: ValueKey(entry.id),
                  entry: entry,
                  uploading: _uploading,
                  onRemove: () => _removeEntry(entry),
                  onRetry: () => unawaited(_retryEntry(entry)),
                  onTitleChanged: () => setState(() {}),
                ),
            ],
          ),
        const SizedBox(height: AppSpacing.sectionGap),
        Text(
          l10n.knowledgeUploadTypeLabel,
          style: AppText.captionSmall.copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.gap),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final key in KnowledgeMaterialTypes.keys)
              AppChip(
                label: KnowledgeMaterialTypes.labelOf(context.l10n, key),
                selected: _type == key,
                onTap: _uploading ? null : () => setState(() => _type = key),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        AppSelectField(
          label: l10n.knowledgeSubjectsTitle,
          value: _subjects.join(' · '),
          placeholder: l10n.knowledgeSubjectsFilter,
          helperText: l10n.knowledgeSubjectsHint,
          enabled: !_uploading,
          onTap: () => unawaited(_chooseSubjects()),
        ),
        if (_subjects.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final subject in _subjects)
                AppChip(
                  label: subject,
                  selected: true,
                  enabled: !_uploading,
                  onRemove: () => setState(() => _subjects.remove(subject)),
                ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.knowledgeUploadAnonymous,
                style: AppText.body.copyWith(color: colors.ink),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            AppSwitch(
              value: _anonymous,
              onChanged: _uploading
                  ? null
                  : (value) => setState(() => _anonymous = value),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.fieldGap),
        if (_entries.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              l10n.knowledgeBatchStatus(_doneCount, _entries.length),
              textAlign: TextAlign.center,
              style: AppText.subtext.copyWith(color: colors.muted),
            ),
          ),
        AppButton.primary(
          label: l10n.knowledgeUploadPublish,
          size: AppButtonSize.large,
          expanded: true,
          loading: _uploading,
          onPressed: canUpload ? () => unawaited(_uploadAll()) : null,
        ),
      ],
    );
  }
}

class _BatchEntryRow extends StatelessWidget {
  const _BatchEntryRow({
    required this.entry,
    required this.uploading,
    required this.onRemove,
    required this.onRetry,
    required this.onTitleChanged,
    super.key,
  });

  final _BatchEntry entry;
  final bool uploading;
  final VoidCallback onRemove;
  final VoidCallback onRetry;
  final VoidCallback onTitleChanged;

  AppLineIcon get _glyph {
    final mimeType = entry.mimeType ?? '';
    if (mimeType.startsWith('image/')) return AppLineIcon.image;
    if (mimeType.startsWith('video/')) return AppLineIcon.video;
    if (mimeType == 'application/pdf') return AppLineIcon.book;
    return AppLineIcon.clipboard;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final preview = entry.previewBytes;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.iconTile),
                child: preview == null
                    ? Container(
                        width: 44,
                        height: 44,
                        color: colors.tintOf(colors.lecture),
                        alignment: Alignment.center,
                        child: AppLineIconWidget(
                          _glyph,
                          size: 20,
                          color: colors.lecture,
                        ),
                      )
                    : Image.memory(
                        preview,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppInputField(
                  controller: entry.titleController,
                  placeholder: l10n.knowledgeUploadTitleHint,
                  maxLength: 200,
                  enabled: !uploading && entry.status != _BatchStatus.done,
                  onChanged: (_) => onTitleChanged(),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (entry.status == _BatchStatus.failed)
                AppIconButton(
                  icon: const AppLineIconWidget(AppLineIcon.refresh),
                  tooltip: l10n.retry,
                  onPressed: uploading ? null : onRetry,
                )
              else if (entry.status == _BatchStatus.done)
                AppLineIconWidget(AppLineIcon.check, color: colors.lecture)
              else
                AppIconButton(
                  icon: const AppLineIconWidget(AppLineIcon.trash),
                  tooltip: l10n.remove,
                  onPressed: uploading ? null : onRemove,
                ),
            ],
          ),
          if (entry.status != _BatchStatus.pending) ...[
            const SizedBox(height: AppSpacing.xs),
            AppProgressBar(
              value: 1,
              indeterminate: entry.status == _BatchStatus.uploading,
              color: entry.status == _BatchStatus.failed
                  ? colors.danger
                  : colors.accent,
            ),
          ],
        ],
      ),
    );
  }
}
