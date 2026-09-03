part of '../create_event_sheet.dart';

class _SheetPickerField extends StatelessWidget {
  const _SheetPickerField({
    required this.icon,
    required this.value,
    required this.onTap,
    this.trailing,
  });

  final AppLineIcon icon;
  final String value;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final trailingWidget = trailing;
    return Container(
      constraints: const BoxConstraints(minHeight: AppControlSize.iconButton),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: trailingWidget == null ? AppSpacing.lg : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppPressable(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
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
            ),
          ),
          ?trailingWidget,
        ],
      ),
    );
  }
}
