import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class LostFoundReportDetailsFields extends StatelessWidget {
  const LostFoundReportDetailsFields({
    required this.titleController,
    required this.locationController,
    required this.descriptionController,
    super.key,
  });

  final TextEditingController titleController;
  final TextEditingController locationController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        NinjaInput(
          controller: titleController,
          autofocus: true,
          maxLength: 120,
          leadingIcon: const AppLineIconWidget(AppLineIcon.box),
          placeholder: l10n.lostFoundTitleHint,
        ),
        const SizedBox(height: AppSpacing.gap),
        NinjaInput(
          controller: locationController,
          maxLength: 200,
          leadingIcon: const AppLineIconWidget(AppLineIcon.pin),
          placeholder: l10n.lostFoundLocationHint,
        ),
        const SizedBox(height: AppSpacing.gap),
        NinjaInput.multiline(
          controller: descriptionController,
          minLines: 3,
          maxLines: 5,
          maxLength: 4000,
          placeholder: l10n.lostFoundDetailsHint,
        ),
      ],
    );
  }
}
