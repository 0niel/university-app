import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.icon = Icons.wifi_off_rounded,
    this.title = 'Нет соединения',
    this.message = 'Проверь интернет. Расписание и заметки доступны офлайн.',
    this.primaryLabel = 'Повторить',
    this.onPrimary,
    this.primaryIcon = Icons.refresh_rounded,
    this.secondaryLabel,
    this.onSecondary,
    this.secondaryIcon,
    this.footnote = 'Синхронизируем, когда сеть вернётся',
  });

  final IconData icon;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final IconData primaryIcon;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final IconData? secondaryIcon;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final secondary = secondaryLabel;
    final footnoteText = footnote;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: colors.surfaceHigh,
                borderRadius: BorderRadius.circular(28),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 42, color: colors.deactiveDarker),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppText.title.copyWith(
                color: colors.active,
                fontSize: 20,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(
                  color: colors.deactiveDarker,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (secondary != null) ...[
                  AppButton.secondary(
                    label: secondary,
                    onPressed: onSecondary,
                    icon: secondaryIcon != null ? Icon(secondaryIcon) : null,
                    size: AppButtonSize.large,
                  ),
                  const SizedBox(width: 10),
                ],
                AppButton.primary(
                  label: primaryLabel,
                  onPressed: onPrimary,
                  icon: Icon(primaryIcon),
                  size: AppButtonSize.large,
                ),
              ],
            ),
            if (footnoteText != null) ...[
              const SizedBox(height: 28),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.warning.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: colors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      footnoteText,
                      style: AppText.caption.copyWith(
                        color: colors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
