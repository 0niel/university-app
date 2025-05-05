import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class NfcMediaSelector extends StatelessWidget {
  final VoidCallback onSelectMedia;
  final VoidCallback? onRemoveMedia;
  final bool hasMedia;
  final bool isVideo;

  const NfcMediaSelector({
    super.key,
    required this.onSelectMedia,
    this.onRemoveMedia,
    required this.hasMedia,
    required this.isVideo,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(isVideo ? Icons.videocam_outlined : Icons.image_outlined, color: colors.active, size: 22),
                const SizedBox(width: 12),
                Text('Медиафайл', style: AppTextStyle.bodyL.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Выберите изображение или видео, которое будет отображаться на карточке пропуска',
              style: AppTextStyle.body.copyWith(color: colors.deactive),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MediaButton(
                    icon: Icons.add,
                    text: hasMedia ? 'Изменить' : 'Выбрать',
                    onPressed: onSelectMedia,
                    isPrimary: !hasMedia,
                  ),
                ),
                if (hasMedia) ...[
                  const SizedBox(width: 12),
                  _MediaButton(
                    icon: Icons.delete_outline,
                    text: 'Удалить',
                    onPressed: onRemoveMedia,
                    color: colors.colorful05,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final Color? color;

  const _MediaButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final buttonColor = color ?? (isPrimary ? colors.primary : colors.background01);
    final textColor = isPrimary ? Colors.white : colors.active;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isPrimary ? BorderSide.none : BorderSide(color: colors.divider),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(text)],
      ),
    );
  }
}
