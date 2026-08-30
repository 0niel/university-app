import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

const _kTelegramBlue = Color(0xFF229ED9);

class AppTelegramLinkCard extends StatelessWidget {
  const AppTelegramLinkCard({
    required this.title,
    required this.handle,
    super.key,
    this.actionLabel = 'Открыть',
    this.onTap,
  })  : isAdd = false,
        addLabel = null;

  const AppTelegramLinkCard.add({
    required String label,
    super.key,
    this.onTap,
  })  : isAdd = true,
        addLabel = label,
        title = '',
        handle = '',
        actionLabel = '';

  final String title;
  final String handle;
  final String actionLabel;
  final bool isAdd;
  final String? addLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (isAdd) {
      return AppPressable(
        onTap: onTap,
        child: AppDashedBorder(
          color: colors.divider,
          radius: AppRadius.xl,
          strokeWidth: 1.5,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  _IconBox(
                    background: colors.surfaceHigh,
                    child: Icon(
                      Icons.add_rounded,
                      size: 22,
                      color: colors.deactiveDarker,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      addLabel ?? '',
                      style: AppText.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.deactive,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      clipBehavior: Clip.antiAlias,
      child: AppPressable(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const _IconBox(
                background: _kTelegramBlue,
                child: Icon(Icons.send_rounded, size: 22, color: Colors.white),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.active,
                      ),
                    ),
                    Text(
                      handle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption.copyWith(color: colors.deactive),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: _kTelegramBlue,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  actionLabel,
                  style: AppText.button.copyWith(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.background, required this.child});

  final Color background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
