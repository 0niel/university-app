part of '../schedule_details_page.dart';

class LessonMaterialUploadSheet extends StatefulWidget {
  const LessonMaterialUploadSheet({
    required this.lesson,
    required this.selectedDate,
    required this.lessonNumber,
    this.filePicker,
    this.imagePicker,
    super.key,
  });

  final LessonSchedulePart lesson;
  final DateTime selectedDate;
  final int lessonNumber;
  final Future<PlatformFile?> Function()? filePicker;
  final Future<XFile?> Function(ImageSource source)? imagePicker;

  @override
  State<LessonMaterialUploadSheet> createState() =>
      _LessonMaterialUploadSheetState();
}

class _LessonMaterialUploadSheetState extends State<LessonMaterialUploadSheet> {
  static const int _maxUploadBytes = 50 * 1024 * 1024;

  final _imagePicker = ImagePicker();
  final _titleController = TextEditingController();

  LessonMaterialType _type = .note;
  _PickedMaterial? _picked;
  var _isPublic = true;
  var _anonymous = false;
  var _uploading = false;
  var _picking = false;
  String? _error;
  String? _uploadError;

  bool get _busy => _uploading || _picking;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    if (_busy) return;
    setState(() {
      _picking = true;
      _error = null;
      _uploadError = null;
    });
    try {
      final file = await (widget.filePicker ?? FilePicker.pickFile)();
      if (file == null || !mounted) return;
      if (file.size > _maxUploadBytes) {
        setState(() => _error = context.l10n.lessonDetailsFileTooLarge);
        return;
      }
      final bytes = await _readBytes(file.readAsByteStream());
      if (bytes == null || !mounted) return;
      _setPicked(
        _PickedMaterial(name: file.name, bytes: bytes, mimeType: null),
      );
    } on Exception {
      if (mounted) setState(() => _error = context.l10n.knowledgeFileError);
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_busy) return;
    setState(() {
      _picking = true;
      _error = null;
      _uploadError = null;
    });
    try {
      final file =
          await (widget.imagePicker?.call(source) ??
              _imagePicker.pickImage(source: source, imageQuality: 90));
      if (file == null || !mounted) return;
      final length = await file.length();
      if (!mounted) return;
      if (length > _maxUploadBytes) {
        setState(() => _error = context.l10n.lessonDetailsFileTooLarge);
        return;
      }
      final bytes = await _readBytes(file.openRead());
      if (bytes == null || !mounted) return;
      _setPicked(
        _PickedMaterial(
          name: file.name,
          bytes: bytes,
          mimeType: file.mimeType ?? 'image/jpeg',
        ),
      );
      setState(() => _type = .board);
    } on Exception {
      if (mounted) setState(() => _error = context.l10n.knowledgeFileError);
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<Uint8List?> _readBytes(Stream<List<int>> stream) async {
    final bytes = BytesBuilder(copy: false);
    await for (final chunk in stream) {
      if (!mounted) return null;
      if (bytes.length + chunk.length > _maxUploadBytes) {
        setState(() => _error = context.l10n.lessonDetailsFileTooLarge);
        return null;
      }
      bytes.add(chunk);
    }
    if (!mounted) return null;
    if (bytes.isEmpty) {
      setState(() => _error = context.l10n.knowledgeFileError);
      return null;
    }
    return bytes.takeBytes();
  }

  void _setPicked(_PickedMaterial material) {
    setState(() {
      _picked = material;
      _error = null;
      if (_titleController.text.trim().isEmpty) {
        final extension = material.name.lastIndexOf('.');
        _titleController.text = extension > 0
            ? material.name.substring(0, extension)
            : material.name;
      }
    });
  }

  Future<void> _upload() async {
    if (_busy) return;
    final picked = _picked;
    final title = _titleController.text.trim();
    if (picked == null) {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.lessonDetailsPickFileFirst,
      );
      return;
    }
    if (title.isEmpty) {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.lessonDetailsAddTitle,
      );
      return;
    }

    final repository = context.read<ScheduleRepository>();
    if (!repository.hasAuthenticatedUser) {
      setState(() => _uploadError = context.l10n.lessonDetailsSignInUpload);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _uploading = true;
      _error = null;
      _uploadError = null;
    });
    try {
      await repository.uploadLessonMaterial(
        CreateLessonMaterialRequest(
          subjectName: widget.lesson.subject,
          lessonDate: widget.selectedDate,
          lessonBellsNumber: widget.lessonNumber,
          lessonUid: widget.lesson.uid,
          materialType: _type,
          title: title,
          fileName: picked.name,
          bytes: picked.bytes,
          mimeType: picked.mimeType,
          isPublic: _isPublic,
          isAnonymous: _anonymous,
        ),
      );
      if (mounted) Navigator.of(context).pop(true);
    } on Exception {
      if (!mounted) return;
      setState(() => _uploadError = context.l10n.knowledgeUploadError);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final picked = _picked;
    return ExcludeFocus(
      excluding: _busy,
      child: AbsorbPointer(
        absorbing: _busy,
        child: Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            if (_picking && picked == null)
              const _DropZoneSkeleton()
            else if (picked == null)
              _DropZone(onTap: () => unawaited(_pickFile()))
            else
              _PickedPreview(
                picked: picked,
                onRemove: () => setState(() {
                  _picked = null;
                  _error = null;
                }),
              ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.gap),
              AppBanner(message: _error!, tone: AppBannerTone.danger),
            ],
            const SizedBox(height: AppSpacing.sectionGap),
            Row(
              spacing: AppSpacing.sm,
              children: [
                Expanded(
                  child: _SourceButton(
                    icon: AppLineIcon.camera,
                    label: context.l10n.lessonDetailsCamera,
                    onTap: () => unawaited(_pickImage(.camera)),
                  ),
                ),
                Expanded(
                  child: _SourceButton(
                    icon: AppLineIcon.image,
                    label: context.l10n.lessonDetailsGallery,
                    onTap: () => unawaited(_pickImage(.gallery)),
                  ),
                ),
                Expanded(
                  child: _SourceButton(
                    icon: AppLineIcon.folder,
                    label: context.l10n.lessonDetailsFiles,
                    onTap: () => unawaited(_pickFile()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.fieldGap),
            Text(
              context.l10n.lessonDetailsTypeHeader,
              style: AppText.captionSmall.copyWith(color: context.colors.muted),
            ),
            const SizedBox(height: AppSpacing.gap),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final type in LessonMaterialType.values)
                  _TypeChip(
                    type: type,
                    selected: _type == type,
                    onTap: () => setState(() => _type = type),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInputField(
              controller: _titleController,
              enabled: !_busy,
              label: context.l10n.lessonDetailsTitleLabel,
              placeholder: context.l10n.lessonDetailsTitleHint,
            ),
            const SizedBox(height: AppSpacing.gap),
            SettingsToggleRow(
              label: context.l10n.lessonDetailsPublicTitle,
              sub: context.l10n.lessonDetailsPublicSub,
              value: _isPublic,
              onChanged: (value) => setState(() => _isPublic = value),
            ),
            SettingsToggleRow(
              label: context.l10n.lessonDetailsAnonymous,
              value: _anonymous,
              onChanged: (value) => setState(() => _anonymous = value),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            AppContextBanner(
              icon: AppLineIcon.spark,
              title: context.l10n.lessonDetailsShurikensReward,
              subtitle: context.l10n.lessonDetailsRewardPre,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_uploadError != null) ...[
              AppBanner(
                message: _uploadError!,
                tone: AppBannerTone.danger,
              ),
              const SizedBox(height: AppSpacing.gap),
            ],
            AppButton.primary(
              label: _uploading
                  ? context.l10n.lessonDetailsUploading
                  : context.l10n.lessonDetailsUploadMaterial,
              expanded: true,
              size: .large,
              loading: _uploading,
              onPressed: _busy ? null : () => unawaited(_upload()),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickedMaterial {
  const _PickedMaterial({
    required this.name,
    required this.bytes,
    required this.mimeType,
  });

  final String name;
  final Uint8List bytes;
  final String? mimeType;
}
