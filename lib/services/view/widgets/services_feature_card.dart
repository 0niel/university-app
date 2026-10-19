import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/services/models/service_entry.dart';

class ServicesFeatureCard extends StatelessWidget {
  const ServicesFeatureCard({
    required this.entry,
    required this.onTap,
    required this.onToggleFavorite,
    required this.editMode,
    required this.favorite,
    super.key,
  });

  final ServiceEntry entry;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final bool editMode;
  final bool favorite;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppFeatureCard(
      key: ValueKey('service-feature-${entry.id}'),
      onTap: onTap,
      leading: AppIconTile(
        icon: entry.model.icon,
        size: AppControlSize.iconTileMedium,
        background: colors.accent.withValues(alpha: .13),
        foreground: colors.accent,
        iconSize: AppIconSize.md,
      ),
      trailing: editMode
          ? AppIconButton(
              key: ValueKey('service-star-${entry.id}'),
              icon: const AppLineIconWidget(AppLineIcon.star),
              tone: favorite
                  ? AppIconButtonTone.primary
                  : AppIconButtonTone.secondary,
              tooltip: favorite
                  ? context.l10n.servicesFavoriteRemove
                  : context.l10n.servicesFavoriteAdd,
              onPressed: onToggleFavorite,
            )
          : AppLineIconWidget(
              AppLineIcon.chevronR,
              color: colors.accent,
            ),
      title: Text(entry.title),
      subtitle: Text(entry.subtitle),
    );
  }
}
