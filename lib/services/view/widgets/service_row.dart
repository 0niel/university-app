import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/services/models/service_entry.dart';

class ServiceRow extends StatelessWidget {
  const ServiceRow({
    required this.entry,
    required this.onTap,
    super.key,
    this.editMode = false,
    this.favorite = false,
    this.onToggleFavorite,
  });

  final ServiceEntry entry;
  final VoidCallback onTap;
  final bool editMode;
  final bool favorite;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = entry.tone;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    return AppPressable(
      key: ValueKey('service-row-${entry.id}'),
      onTap: onTap,
      semanticsButton: true,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          14,
          editMode ? 6 : 10,
          editMode ? 8 : 12,
          editMode ? 6 : 10,
        ),
        child: Row(
          children: [
            AppIconTile(
              icon: entry.model.icon,
              background: tone == null ? colors.surface2 : colors.tintOf(tone),
              foreground: tone ?? colors.ink,
              iconSize: 22,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    maxLines: largeText ? null : 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.cell.copyWith(color: colors.ink),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    entry.subtitle,
                    maxLines: largeText ? null : 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption.copyWith(
                      color: colors.muted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: editMode ? 8 : 12),
            if (editMode)
              AppIconButton(
                key: ValueKey('service-star-${entry.id}'),
                icon: const AppLineIconWidget(
                  AppLineIcon.star,
                  size: 15,
                  strokeWidth: 2.2,
                ),
                tone: favorite
                    ? AppIconButtonTone.primary
                    : AppIconButtonTone.secondary,
                shape: AppIconButtonShape.circle,
                size: AppIconButtonSize.small,
                foregroundColor: favorite ? colors.onAccent : colors.muted,
                iconSize: 15,
                strokeWidth: 2.2,
                tooltip: favorite
                    ? context.l10n.servicesFavoriteRemove
                    : context.l10n.servicesFavoriteAdd,
                onPressed: onToggleFavorite,
              )
            else
              AppLineIconWidget(
                AppLineIcon.chevronR,
                size: AppIconSize.xs,
                color: colors.muted2,
                strokeWidth: 2.4,
              ),
          ],
        ),
      ),
    );
  }
}
