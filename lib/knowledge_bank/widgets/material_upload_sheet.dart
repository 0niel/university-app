import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/knowledge_bank/config/knowledge_material_types.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'price_step_button.dart';

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
  });

  final CampusRepository repository;
  final MaterialFilePicker? filePickerBuilder;
  final MaterialFileReader? fileReaderBuilder;

  @override
  State<MaterialUploadSheet> createState() => _MaterialUploadSheetState();
}

class _MaterialUploadSheetState extends State<MaterialUploadSheet> {
  final _title = TextEditingController();
  final _subject = TextEditingController();
  String _type = 'note';
  int _price = 0;
  bool _anonymous = false;
  bool _saving = false;

  String? _fileName;
  Uint8List? _fileBytes;
  String? _mimeType;

  @override
  void dispose() {
    _title.dispose();
    _subject.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final file = await (widget.filePickerBuilder ?? FilePicker.pickFile)();
      if (file == null || !mounted || file.size > _kMaxUploadBytes) return;
      final bytes = await (widget.fileReaderBuilder ?? _readFile)(file);
      if (!mounted || bytes.length > _kMaxUploadBytes) return;
      setState(() {
        _fileName = file.name;
        _fileBytes = bytes;
        _mimeType = null;
        if (_title.text.trim().isEmpty) {
          final extensionIndex = file.name.lastIndexOf('.');
          _title.text = extensionIndex > 0
              ? file.name.substring(0, extensionIndex)
              : file.name;
        }
      });
    } on Exception catch (error, stackTrace) {
      log(
        'Failed to pick a material file',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty || _saving) return;
    setState(() => _saving = true);
    try {
      await widget.repository.createPublicMaterial(
        title: title,
        subjectName: _subject.text.trim(),
        materialType: _type,
        price: _price,
        isAnonymous: _anonymous,
        fileName: _fileName,
        fileBytes: _fileBytes,
        mimeType: _mimeType,
      );
      if (mounted) Navigator.of(context).pop(true);
    } on Exception catch (error, stackTrace) {
      log('Failed to upload a material', error: error, stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final bytes = _fileBytes;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppPressable(
          onTap: () => unawaited(_pickFile()),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(NinjaRadius.card),
            ),
            child: Column(
              children: [
                AppLineIconWidget(
                  AppLineIcon.folder,
                  color: colors.muted,
                ),
                const SizedBox(height: 10),
                Text(
                  _fileName ?? l10n.knowledgeUploadFilePrompt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: NinjaText.body.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bytes == null
                      ? l10n.knowledgeUploadFileHint
                      : l10n.knowledgeUploadFileSize(
                          (bytes.length / 1024 / 1024).toStringAsFixed(1),
                        ),
                  textAlign: TextAlign.center,
                  style: NinjaText.helper.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          l10n.knowledgeUploadTypeLabel,
          style: NinjaText.microLabel.copyWith(color: colors.muted),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final key in KnowledgeMaterialTypes.keys)
              NinjaChip(
                label: KnowledgeMaterialTypes.labelOf(l10n, key),
                selected: _type == key,
                onTap: () => setState(() => _type = key),
              ),
          ],
        ),
        const SizedBox(height: 14),
        NinjaInput(
          controller: _title,
          placeholder: l10n.knowledgeUploadTitleHint,
        ),
        const SizedBox(height: 10),
        NinjaInput(
          controller: _subject,
          placeholder: l10n.knowledgeUploadSubjectHint,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.knowledgeUploadPriceLabel,
                    style: NinjaText.body.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.knowledgeUploadPriceHint,
                    style: NinjaText.subtext.copyWith(
                      fontSize: 12,
                      color: colors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _PriceStepButton(
              icon: AppLineIcon.minus,
              semanticLabel: l10n.knowledgeUploadDecreasePrice,
              onTap: _price <= 0
                  ? null
                  : () => setState(() => _price = (_price - 10).clamp(0, 500)),
            ),
            SizedBox(
              width: 62,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppNinjaMark(size: 12, color: colors.ink),
                  const SizedBox(width: 5),
                  Text(
                    '$_price',
                    style: NinjaText.tabular(
                      NinjaText.body.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _PriceStepButton(
              icon: AppLineIcon.plus,
              semanticLabel: l10n.knowledgeUploadIncreasePrice,
              onTap: () => setState(() => _price = (_price + 10).clamp(0, 500)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.knowledgeUploadAnonymous,
                style: NinjaText.body.copyWith(color: colors.ink),
              ),
            ),
            const SizedBox(width: 12),
            NinjaSwitch(
              value: _anonymous,
              onChanged: (value) => setState(() => _anonymous = value),
            ),
          ],
        ),
        const SizedBox(height: 16),
        NinjaBanner(
          title: l10n.knowledgeUploadReward(_kUploadRewardAmount),
        ),
        const SizedBox(height: 18),
        NinjaButton.primary(
          label: _saving
              ? l10n.knowledgeUploadPublishing
              : l10n.knowledgeUploadPublish,
          size: NinjaButtonSize.large,
          expanded: true,
          loading: _saving,
          onPressed: _saving ? null : () => unawaited(_save()),
        ),
      ],
    );
  }
}

Future<Uint8List> _readFile(PlatformFile file) => file.readAsBytes();
