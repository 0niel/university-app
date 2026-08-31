part of 'ninja_invite_sheet.dart';

class InviteCircleAction extends StatelessWidget {
  const InviteCircleAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    super.key,
  });

  final AppLineIcon icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return NinjaIconButton(
      icon: AppLineIconWidget(
        icon,
        size: 20,
        color: colors.ink,
      ),
      tooltip: tooltip,
      onPressed: onTap,
    );
  }
}
