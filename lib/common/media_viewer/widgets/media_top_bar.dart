import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class MediaTopBarAction {
  const MediaTopBarAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.busy = false,
  });

  final AppLineIcon icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool busy;
}

class MediaTopBar extends StatelessWidget {
  const MediaTopBar({
    required this.title,
    required this.subtitle,
    required this.onClose,
    required this.closeSemanticsLabel,
    this.actions = const [],
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback onClose;
  final String closeSemanticsLabel;
  final List<MediaTopBarAction> actions;

  @override
  Widget build(BuildContext context) {
    const dark = AppColors.dark;
    final top = MediaQuery.paddingOf(context).top + AppSpacing.sm;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        top,
        AppSpacing.screen,
        AppSpacing.zero,
      ),
      child: Row(
        children: [
          AppIconButton(
            icon: const AppLineIconWidget(AppLineIcon.close),
            tooltip: closeSemanticsLabel,
            size: AppIconButtonSize.small,
            shape: AppIconButtonShape.circle,
            backgroundColor: dark.surface2,
            foregroundColor: dark.ink,
            onPressed: onClose,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body.copyWith(
                    color: dark.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.subtext.copyWith(color: dark.muted),
                  ),
                ],
              ],
            ),
          ),
          for (final action in actions) ...[
            const SizedBox(width: AppSpacing.sm),
            AppIconButton(
              icon: action.busy
                  ? const AppSpinner(size: 18)
                  : AppLineIconWidget(action.icon),
              tooltip: action.tooltip,
              size: AppIconButtonSize.small,
              shape: AppIconButtonShape.circle,
              backgroundColor: dark.surface2,
              foregroundColor: dark.ink,
              onPressed: action.busy ? null : action.onPressed,
            ),
          ],
        ],
      ),
    );
  }
}
