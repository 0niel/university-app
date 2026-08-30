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
    final colors = context.ninja;
    return AppPressable(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: NinjaMetrics.minTouchTarget,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(NinjaRadius.button),
        ),
        child: Row(
          children: [
            AppLineIconWidget(icon, size: 17, color: colors.muted),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: NinjaText.tabular(
                  NinjaText.body.copyWith(color: colors.ink),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
