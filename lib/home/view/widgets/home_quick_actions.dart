import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({
    required this.services,
    required this.onAll,
    this.loading = false,
    super.key,
  });
  final List<ServiceEntry> services;
  final VoidCallback onAll;
  final bool loading;

  @override
  Widget build(BuildContext context) => AppTourAnchor(
    target: .homeServices,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionTitle(
          title: context.l10n.homeSectionSmartChips,
          action: context.l10n.homeAllServices,
          onActionTap: onAll,
        ),
        if (services.isEmpty && loading)
          const _HomeQuickActionsSkeleton()
        else if (services.isEmpty)
          AppEmptyState.compact(title: context.l10n.homeFavoritesEmpty)
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final scale = MediaQuery.textScalerOf(context).scale(1);
              final columns = scale > 1.5 || constraints.maxWidth < 300 ? 3 : 5;
              final width =
                  (constraints.maxWidth - 4 * (columns - 1)) / columns;
              return Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (final entry in services)
                    AppPressable(
                      onTap: () => entry.open(context),
                      semanticsLabel: entry.title,
                      child: SizedBox(
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 8,
                          ),
                          child: Column(
                            children: [
                              AppIconTile(
                                icon: entry.model.icon,
                                size: 48,
                                radius: AppRadius.banner,
                                background: context.colors.surface,
                                foreground: entry.tone ?? entry.model.color,
                                iconSize: 22,
                              ),
                              const SizedBox(height: 7),
                              Text(
                                _shortTitle(entry, context.l10n),
                                textAlign: TextAlign.center,
                                maxLines: scale > 1.5 ? 3 : 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.sans(
                                  10.5,
                                  FontWeight.w600,
                                  height: 1.2,
                                ).copyWith(color: context.colors.muted),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
      ],
    ),
  );

  String _shortTitle(ServiceEntry entry, AppLocalizations l10n) =>
      switch (entry.model.routePath) {
        '/services/map' => l10n.servicesMap,
        '/services/free-rooms' => l10n.classrooms,
        '/services/nfc' => l10n.homePass,
        '/schedule/session' => l10n.serviceExamsTitle,
        _ => entry.title,
      };
}

class _HomeQuickActionsSkeleton extends StatelessWidget {
  const _HomeQuickActionsSkeleton();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < 5; i++) ...[
        if (i > 0) const SizedBox(width: 4),
        const Expanded(
          child: Column(
            children: [
              AppSkeleton(height: 48, radius: AppRadius.banner),
              SizedBox(height: 7),
              AppSkeleton(height: 10, widthFactor: .6),
            ],
          ),
        ),
      ],
    ],
  );
}
