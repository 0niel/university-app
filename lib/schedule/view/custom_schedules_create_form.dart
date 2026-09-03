part of 'custom_schedules_page.dart';

class _CustomSchedulesCreateForm extends StatelessWidget {
  const _CustomSchedulesCreateForm({
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.onSubmit,
    this.isEditing = false,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final VoidCallback onSubmit;
  final bool isEditing;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: .min,
        children: [
          AppInputField(
            controller: nameController,
            label: l10n.customSchedulesNameLabel,
            placeholder: l10n.customSchedulesNameHint,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.customSchedulesNameRequired;
              }
              if (value.length > 50) return l10n.customSchedulesNameTooLong;
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          AppInputField(
            controller: descriptionController,
            label: l10n.customSchedulesDescLabel,
            placeholder: l10n.customSchedulesDescHint,
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.xlg),
          AppButton.primary(
            label: isEditing
                ? l10n.customSchedulesSaveChanges
                : l10n.customSchedulesCreate,
            onPressed: onSubmit,
            size: .large,
            expanded: true,
          ),
        ],
      ),
    );
  }
}
