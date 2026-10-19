import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class KitAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KitAppBar({
    required this.title,
    super.key,
    this.leading,
    this.actions = const [],
  });

  final String title;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Size get preferredSize => const .fromHeight(AppControlSize.bottomBar);

  @override
  Widget build(BuildContext context) {
    final leading = this.leading;
    return SizedBox(
      height: preferredSize.height,
      child: Padding(
        padding: const .symmetric(horizontal: AppSpacing.screen),
        child: Row(
          children: [
            if (leading != null) ...[
              leading,
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: .ellipsis,
                style: AppText.title.copyWith(color: context.colors.ink),
              ),
            ),
            for (final action in actions) ...[
              const SizedBox(width: AppSpacing.sm),
              action,
            ],
          ],
        ),
      ),
    );
  }
}
