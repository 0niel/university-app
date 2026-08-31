import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/config/university_config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/cubit/lost_found_cubit.dart';
import 'package:rtu_mirea_app/lost_and_found/models/models.dart';
import 'package:rtu_mirea_app/lost_and_found/utils/lost_found_image_intake.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_category_picker.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_photo_picker.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_report_contact_fields.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_report_details_fields.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_report_status_selector.dart';

class LostFoundReportSheet extends StatefulWidget {
  const LostFoundReportSheet({super.key});

  @override
  State<LostFoundReportSheet> createState() => _LostFoundReportSheetState();
}

class _LostFoundReportSheetState extends State<LostFoundReportSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _telegramController = TextEditingController();
  final _phoneController = TextEditingController();
  final _picker = ImagePicker();
  final _images = <LostFoundImageUpload>[];

  LostFoundItemStatus _status = .found;
  late String _category;
  bool _showContact = false;

  @override
  void initState() {
    super.initState();
    _category =
        UniversityConfig.current.lostFoundCategoryKeys.firstOrNull ?? 'other';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _telegramController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _addPicked(Iterable<XFile> files) async {
    final room = LostFoundImageIntake.maxImages - _images.length;
    final valid = <LostFoundImageUpload>[];
    for (final file in files.take(room)) {
      final upload = await LostFoundImageIntake.read(file);
      if (upload == null) {
        if (mounted) _showImageError();
        continue;
      }
      valid.add(upload);
    }
    if (!mounted || valid.isEmpty) return;
    setState(() => _images.addAll(valid));
  }

  void _showImageError() => NinjaToastHost.maybeOf(context)?.show(
    NinjaToastData(
      message: context.l10n.lostFoundImageError,
      showCheck: false,
    ),
  );

  Future<void> _pickFromGallery() async {
    if (_images.length >= LostFoundImageIntake.maxImages) return;
    try {
      await _addPicked(await _picker.pickMultiImage(imageQuality: 80));
    } on Exception {
      if (mounted) _showImageError();
    }
  }

  Future<void> _pickFromCamera() async {
    if (_images.length >= LostFoundImageIntake.maxImages) return;
    try {
      final file = await _picker.pickImage(
        source: .camera,
        imageQuality: 80,
      );
      if (file != null) await _addPicked([file]);
    } on Exception {
      if (mounted) _showImageError();
    }
  }

  Future<void> _save() async {
    final draft = LostFoundReportDraft(
      title: _titleController.text,
      status: _status,
      category: _category,
      description: _descriptionController.text,
      telegram: _telegramController.text,
      phoneNumber: _phoneController.text,
      location: _locationController.text,
      showContact: _showContact,
      images: _images,
    );
    if (!draft.isValid) {
      _showPublishError();
      return;
    }
    final created = await context.read<LostFoundCubit>().create(draft);
    if (!mounted) return;
    if (created) {
      Navigator.of(context).pop();
    } else {
      _showPublishError();
    }
  }

  void _showPublishError() => NinjaToastHost.maybeOf(context)?.show(
    NinjaToastData(
      message: context.l10n.lostFoundPublishError,
      showCheck: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isCreating = context.select<LostFoundCubit, bool>(
      (cubit) => cubit.state.isCreating,
    );
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LostFoundReportStatusSelector(
            value: _status,
            onChanged: (value) => setState(() => _status = value),
          ).animateSectionEntrance(),
          const SizedBox(height: AppSpacing.xlg),
          LostFoundReportDetailsFields(
            titleController: _titleController,
            locationController: _locationController,
            descriptionController: _descriptionController,
          ).animateSectionEntrance(index: 1),
          const SizedBox(height: AppSpacing.lg),
          LostFoundCategoryPicker(
            keys: UniversityConfig.current.lostFoundCategoryKeys,
            value: _category,
            padding: EdgeInsets.zero,
            onChanged: (value) => setState(() => _category = value),
          ).animateSectionEntrance(index: 2),
          const SizedBox(height: AppSpacing.xlg),
          LostFoundPhotoPicker(
            images: _images,
            onAddFromGallery: () => unawaited(_pickFromGallery()),
            onAddFromCamera: () => unawaited(_pickFromCamera()),
            onRemove: (index) => setState(() => _images.removeAt(index)),
          ).animateSectionEntrance(index: 3),
          const SizedBox(height: AppSpacing.xlg),
          LostFoundReportContactFields(
            telegramController: _telegramController,
            phoneController: _phoneController,
            showContact: _showContact,
            onShowContactChanged: (value) =>
                setState(() => _showContact = value),
          ).animateSectionEntrance(index: 4),
          const SizedBox(height: AppSpacing.xlg),
          NinjaButton.primary(
            label: isCreating
                ? l10n.lostFoundPublishing
                : l10n.lostFoundPublish,
            icon: const AppLineIconWidget(AppLineIcon.upload),
            size: NinjaButtonSize.large,
            expanded: true,
            loading: isCreating,
            onPressed: isCreating ? null : () => unawaited(_save()),
          ),
        ],
      ),
    );
  }
}
