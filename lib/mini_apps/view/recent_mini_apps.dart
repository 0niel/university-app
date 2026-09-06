part of 'mini_apps_page.dart';

class _RecentMiniApps extends StatelessWidget {
  const _RecentMiniApps({required this.apps, required this.onOpen});

  final List<MiniApp> apps;
  final ValueChanged<MiniApp> onOpen;

  static double height(BuildContext context) =>
      (MediaQuery.textScalerOf(context).scale(16) * 2.6 + 28).clamp(
        80,
        double.infinity,
      );

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height(context),
    child: LayoutBuilder(
      builder: (context, constraints) => ListView.separated(
        key: const ValueKey('mini-apps-recents'),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: apps.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final app = apps[index];
          return AppCard(
            key: ValueKey('recent-${app.id}'),
            width: (constraints.maxWidth * .75).clamp(220, 320),
            padding: const EdgeInsets.all(AppSpacing.md),
            radius: AppRadius.field,
            semanticsLabel: app.name,
            onTap: () => onOpen(app),
            child: ExcludeSemantics(
              child: Row(
                children: [
                  MiniAppIconTile(
                    emoji: app.iconEmoji,
                    accent: context.colors.accent,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      app.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.headline.copyWith(
                        color: context.colors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
