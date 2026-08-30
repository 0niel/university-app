import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/widgets/ninja_form_input.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ScheduleSelectorCreateForm extends StatelessWidget {
  const ScheduleSelectorCreateForm({
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.createNewSchedule,
            style: NinjaText.headline.copyWith(color: context.ninja.ink),
          ),
          const SizedBox(height: 16),
          NinjaFormInput(
            controller: nameController,
            label: l10n.scheduleNameLabel,
            placeholder: l10n.scheduleNamePlaceholder,
            onValidate: (value) {
              if (value == null || value.isEmpty) {
                return l10n.enterScheduleName;
              }
              if (value.length > 50) {
                return l10n.nameTooLong;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          NinjaInput(
            controller: descriptionController,
            label: l10n.descriptionOptionalLabel,
            placeholder: l10n.addScheduleDescriptionPlaceholder,
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: .infinity,
            child: NinjaButton.primary(
              onPressed: onSubmit,
              label: l10n.createAndAddClass,
              size: .large,
              expanded: true,
            ),
          ),
        ],
      ),
    );
  }
}
