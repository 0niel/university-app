import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:rtu_mirea_app/knowledge_bank/config/knowledge_material_types.dart';
import 'package:rtu_mirea_app/knowledge_bank/utils/image_preview.dart';
import 'package:rtu_mirea_app/knowledge_bank/widgets/material_subject_picker.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

const int _kUploadRewardAmount = 30;
const int _kMaxUploadBytes = 50 * 1024 * 1024;

typedef MaterialFilePicker = Future<PlatformFile?> Function();
typedef MaterialFileReader = Future<Uint8List> Function(PlatformFile file);

class MaterialUploadSheet extends StatefulWidget {
  const MaterialUploadSheet({
    required this.repository,
    super.key,
    this.filePickerBuilder,
    this.fileReaderBuilder,
    this.initialSubjects = const [],
  });

  final CampusRepository repository;
  final MaterialFilePicker? filePickerBuilder;
  final MaterialFileReader? fileReaderBuilder;
  final List<String> initialSubjects;

  @override
  State<MaterialUploadSheet> createState() => _MaterialUploadSheetState();
}

class _MaterialUploadSheetState extends State<MaterialUploadSheet> {
  final _title = TextEditingController();
  Set<String> _subjects = {};
  String _type = 'note';
  int _price = 0;
  bool _anonymous = false;
  bool _saving = false;
  bool _hasTitle = false;
  bool _picking = false;
  bool _fileFailed = false;
  bool _uploadFailed = false;

  String? _fileName;
  Uint8List? _fileBytes;
  String? _mimeType;
  Uint8List? _previewBytes;
  int? _previewWidth;
  int? _previewHeight;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    if (_saving || _picking) return;
    setState(() {
      _picking = true;
      _fileFailed = false;
    });
    try {
      final file = await (widget.filePickerBuilder ?? FilePicker.pickFile)();
      if (file == null || !mounted) return;
      if (file.size > _kMaxUploadBytes) {
        setState(() => _fileFailed = true);
        return;
      }
      final bytes = await (widget.fileReaderBuilder ?? _readFile)(file);
      if (!mounted) return;
      if (bytes.isEmpty || bytes.length > _kMaxUploadBytes) {
        setState(() => _fileFailed = true);
        return;
      }
      final mimeType = lookupMimeType(file.name, headerBytes: bytes);
      final preview = mimeType != null && mimeType.startsWith('image/')
          ? await generateImagePreview(bytes)
          : null;
      if (!mounted) return;
      setState(() {
        _fileName = file.name;
        _fileBytes = bytes;
        _mimeType = mimeType;
        _previewBytes = preview?.bytes;
        _previewWidth = preview?.width;
        _previewHeight = preview?.height;
        if (_title.text.trim().isEmpty) {
          final extensionIndex = file.name.lastIndexOf('.');
          _title.text = extensionIndex > 0
              ? file.name.substring(0, extensionIndex)
              : file.name;
        }
        _hasTitle = _title.text.trim().isNotEmpty;
      });
    } on Object catch (error, stackTrace) {
      log(
        'Failed to pick a material file',
        error: error,
        stackTrace: stackTrace,
      );
      if (mounted) setState(() => _fileFailed = true);
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    final fileName = _fileName;
    final fileBytes = _fileBytes;
    if (title.isEmpty ||
        title.length > 200 ||
        _subjects.isEmpty ||
        fileName == null ||
        fileBytes == null ||
        _saving) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _saving = true;
      _uploadFailed = false;
    });
    try {
      await widget.repository.createPublicMaterial(
        title: title,
        subjectName: _subjects.first,
        subjectNames: _subjects.toList(growable: false),
        materialType: _type,
        price: _price,
        isAnonymous: _anonymous,
        fileName: fileName,
        fileBytes: fileBytes,
        mimeType: _mimeType,
        previewBytes: _previewBytes,
        previewMimeType: _previewBytes == null ? null : 'image/png',
        width: _previewWidth,
        height: _previewHeight,
      );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error, stackTrace) {
      log('Failed to upload a material', error: error, stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          _saving = false;
          _uploadFailed = true;
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final bytes = _fileBytes;
    final canSave =
        !_saving &&
        !_picking &&
        bytes != null &&
        _fileName != null &&
        _hasTitle &&
        _title.text.trim().length <= 200 &&
        _subjects.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppPressable(
          onTap: _saving || _picking ? null : () => unawaited(_pickFile()),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.contentGap,
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Column(
              children: [
                if (_picking)
                  const NinjaSpinner(size: 24)
                else if (_previewBytes != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.iconTile),
                    child: Image.memory(
                      _previewBytes!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  AppLineIconWidget(
                    AppLineIcon.folder,
                    color: colors.muted,
                  ),
                const SizedBox(height: AppSpacing.gap),
                Text(
                  _fileName ?? l10n.knowledgeUploadFilePrompt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  bytes == null
                      ? l10n.knowledgeUploadFileHint
                      : l10n.knowledgeUploadFileSize(
                          (bytes.length / 1024 / 1024).toStringAsFixed(1),
                        ),
                  textAlign: TextAlign.center,
                  style: AppText.captionSmall.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.fieldGap),
        if (_fileFailed) ...[
          Semantics(
            liveRegion: true,
            child: AppBanner(
              message: l10n.knowledgeFileError,
              tone: AppBannerTone.danger,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
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
                label: KnowledgeMaterialTypes.labelOf(l10n, key),
                selected: _type == key,
                onTap: _saving ? null : () => setState(() => _type = key),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        AppInputField(
          controller: _title,
          enabled: !_saving,
          placeholder: l10n.knowledgeUploadTitleHint,
          maxLength: 200,
          onChanged: (value) => setState(
            () => _hasTitle = value.trim().isNotEmpty,
          ),
        ),
        const SizedBox(height: AppSpacing.gap),
        AppSelectField(
          label: l10n.knowledgeSubjectsTitle,
          value: _subjects.join(' · '),
          placeholder: l10n.knowledgeSubjectsFilter,
          helperText: l10n.knowledgeSubjectsHint,
          enabled: !_saving,
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
                  enabled: !_saving,
                  onRemove: () => setState(() => _subjects.remove(subject)),
                ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.knowledgeUploadPriceLabel,
                    style: AppText.body.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    l10n.knowledgeUploadPriceHint,
                    style: AppText.subtext.copyWith(
                      fontSize: 12,
                      color: colors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            AppStepper(
              value: _price,
              max: 500,
              decrementSemanticLabel: l10n.knowledgeUploadDecreasePrice,
              incrementSemanticLabel: l10n.knowledgeUploadIncreasePrice,
              onChanged: _saving
                  ? null
                  : (value) => setState(() {
                      _price = (_price + (value > _price ? 10 : -10)).clamp(
                        0,
                        500,
                      );
                    }),
            ),
          ],
        ),
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
              onChanged: _saving
                  ? null
                  : (value) => setState(() => _anonymous = value),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        AppBanner(
          message: l10n.knowledgeUploadReward(_kUploadRewardAmount),
        ),
        const SizedBox(height: AppSpacing.fieldGap),
        if (_uploadFailed) ...[
          Semantics(
            liveRegion: true,
            child: AppBanner(
              message: l10n.knowledgeUploadError,
              tone: AppBannerTone.danger,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        AppButton.primary(
          label: _saving
              ? l10n.knowledgeUploadPublishing
              : l10n.knowledgeUploadPublish,
          size: AppButtonSize.large,
          expanded: true,
          loading: _saving,
          onPressed: canSave ? () => unawaited(_save()) : null,
        ),
      ],
    );
  }
}

Future<Uint8List> _readFile(PlatformFile file) async {
  final bytes = BytesBuilder(copy: false);
  await for (final chunk in file.readAsByteStream()) {
    if (bytes.length + chunk.length > _kMaxUploadBytes) {
      throw const FormatException('Material exceeds the upload limit');
    }
    bytes.add(chunk);
  }
  return bytes.takeBytes();
}
