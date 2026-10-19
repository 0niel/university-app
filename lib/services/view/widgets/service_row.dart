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
    this.compact = false,
  });

  final ServiceEntry entry;
  final VoidCallback onTap;
  final bool editMode;
  final bool favorite;
  final VoidCallback? onToggleFavorite;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = entry.tone ?? colors.accent;
    final icon = AppIconTile(
      icon: entry.model.icon,
      size: AppControlSize.iconTileCompact,
      background: colors.tintOf(tone),
      foreground: tone,
      iconSize: AppIconSize.md,
    );
    final control = editMode
        ? AppIconButton(
            key: ValueKey('service-star-${entry.id}'),
            icon: const AppLineIconWidget(AppLineIcon.star, size: 17),
            tone: favorite
                ? AppIconButtonTone.primary
                : AppIconButtonTone.secondary,
            size: AppIconButtonSize.small,
            tooltip: favorite
                ? context.l10n.servicesFavoriteRemove
                : context.l10n.servicesFavoriteAdd,
            onPressed: onToggleFavorite,
          )
        : AppLineIconWidget(
            favorite ? AppLineIcon.star : AppLineIcon.chevronR,
            size: 15,
            color: favorite ? tone : colors.muted2,
          );
    return AppActionTile(
      key: ValueKey('service-row-${entry.id}'),
      onTap: onTap,
      compact: compact,
      tint: tone,
      leading: icon,
      title: Text(entry.title),
      subtitle: entry.subtitle.isEmpty ? null : Text(entry.subtitle),
      trailing: control,
    );
  }
}
