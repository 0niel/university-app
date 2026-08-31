part of '../schedule_details_page.dart';

class _UploadMaterialSheet extends StatefulWidget {
  const _UploadMaterialSheet({
    required this.lesson,
    required this.selectedDate,
    required this.lessonNumber,
  });

  final LessonSchedulePart lesson;
  final DateTime selectedDate;
  final int lessonNumber;

  @override
  State<_UploadMaterialSheet> createState() => _UploadMaterialSheetState();
}

class _UploadMaterialSheetState extends State<_UploadMaterialSheet> {
  final _imagePicker = ImagePicker();
  final _titleController = TextEditingController();

  LessonMaterialType _type = .note;
  _PickedMaterial? _picked;
  var _isPublic = true;
  var _anonymous = false;
  var _uploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final file = await FilePicker.pickFile();
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    _setPicked(_PickedMaterial(name: file.name, bytes: bytes, mimeType: null));
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await _imagePicker.pickImage(source: source, imageQuality: 90);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    _setPicked(
      _PickedMaterial(
        name: file.name,
        bytes: bytes,
        mimeType: file.mimeType ?? 'image/jpeg',
      ),
    );
    setState(() => _type = .board);
  }

  void _setPicked(_PickedMaterial material) {
    if (material.bytes.length > 50 * 1024 * 1024) {
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.lessonDetailsFileTooLarge,
      );
      return;
    }
    setState(() {
      _picked = material;
      if (_titleController.text.trim().isEmpty) {
        _titleController.text =
            material.name.split('.').firstOrNull ?? material.name;
      }
    });
  }

  Future<void> _upload() async {
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

    setState(() => _uploading = true);
    try {
      await context.read<ScheduleRepository>().uploadLessonMaterial(
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
    } on Exception catch (_) {
      if (!mounted) return;
      showNinjaToast(
        context,
        showCheck: false,
        message: context.l10n.lessonDetailsSignInUpload,
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        _DropZone(picked: _picked, onTap: () => unawaited(_pickFile())),
        const SizedBox(height: 14),
        Row(
          spacing: 8,
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
        const SizedBox(height: 18),
        Text(
          context.l10n.lessonDetailsTypeHeader,
          style: NinjaText.microLabel.copyWith(color: context.ninja.muted),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final type in LessonMaterialType.values)
              _TypeChip(
                type: type,
                selected: _type == type,
                onTap: () => setState(() => _type = type),
              ),
          ],
        ),
        const SizedBox(height: 16),
        NinjaInput(
          controller: _titleController,
          label: context.l10n.lessonDetailsTitleLabel,
          placeholder: context.l10n.lessonDetailsTitleHint,
        ),
        const SizedBox(height: 10),
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
        const SizedBox(height: 14),
        Container(
          padding: const .all(14),
          decoration: BoxDecoration(
            color: context.ninja.surfaceAlt,
            borderRadius: .circular(NinjaRadius.card),
          ),
          child: Row(
            spacing: 10,
            children: [
              AppNinjaMark(size: 16, color: context.ninja.brandInk),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: context.l10n.lessonDetailsRewardPre),
                      TextSpan(
                        text: context.l10n.lessonDetailsShurikensReward,
                        style: TextStyle(color: context.ninja.brandInk),
                      ),
                    ],
                  ),
                  style: NinjaText.subtext.copyWith(
                    color: context.ninja.mutedDark,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        NinjaButton.primary(
          label: _uploading
              ? context.l10n.lessonDetailsUploading
              : context.l10n.lessonDetailsUploadMaterial,
          expanded: true,
          size: .large,
          loading: _uploading,
          onPressed: _uploading ? null : () => unawaited(_upload()),
        ),
      ],
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
