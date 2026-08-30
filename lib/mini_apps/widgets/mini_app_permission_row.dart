part of 'mini_app_consent_sheet.dart';

class MiniAppPermissionRow extends StatelessWidget {
  const MiniAppPermissionRow({
    required this.permission,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final MiniAppPermission permission;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      margin: const .only(bottom: 8),
      padding: const .symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Row(
        children: [
          AppLineIconWidget(
            miniAppPermissionIcon(permission),
            size: 18,
            color: colors.muted,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  miniAppPermissionLabel(context, permission),
                  style: NinjaText.body.copyWith(color: colors.ink),
                ),
                Text(
                  miniAppPermissionDescription(context, permission),
                  style: NinjaText.helper.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          NinjaSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
