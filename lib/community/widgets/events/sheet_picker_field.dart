part of '../create_event_sheet.dart';

class _SheetPickerField extends StatelessWidget {
  const _SheetPickerField({
    required this.icon,
    required this.value,
    required this.onTap,
  });

  final AppLineIcon icon;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AppControlSize.iconButton,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          children: [
            AppLineIconWidget(icon, size: 17, color: colors.muted),
            const SizedBox(width: AppSpacing.gap),
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.tabular(
                  AppText.body.copyWith(color: colors.ink),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
