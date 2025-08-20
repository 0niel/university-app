import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template lock_icon}
/// Reusable lock icon.
/// {@endtemplate}
class LockIcon extends StatelessWidget {
  /// {@macro lock_icon}
  const LockIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.onSurface.withOpacity(0.25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.lock,
              size: AppSpacing.lg,
              color: colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
