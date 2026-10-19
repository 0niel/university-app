part of 'mini_apps_catalog.dart';

class _RecentMiniApps extends StatelessWidget {
  const _RecentMiniApps({required this.apps, required this.onOpen});

  final List<MiniApp> apps;
  final ValueChanged<MiniApp> onOpen;

  static double height(BuildContext context) =>
      68 + MediaQuery.textScalerOf(context).scale(13) * 2.4;

  static double width(BuildContext context) =>
      (66 + MediaQuery.textScalerOf(context).scale(13) * 2).clamp(92, 148);

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height(context),
    child: AppGlassBatch(
      child: ListView.separated(
        key: const ValueKey('mini-apps-recents'),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: apps.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final app = apps[index];
          final colors = context.colors;
          final accent = MiniAppIconTile.resolveAccent(
            app.accentColor,
            fallback: colors.accent,
          );
          return SizedBox(
            width: width(context),
            child: AppReveal(
              index: index,
              identity: app.id,
              child: AppPressable(
                key: ValueKey('recent-${app.id}'),
                semanticsLabel: app.name,
                semanticsButton: true,
                haptics: true,
                onTap: () => onOpen(app),
                child: ExcludeSemantics(
                  child: Column(
                    children: [
                      AppGlassSurface(
                        role: AppGlassRole.control,
                        tone: AppGlassTone.accent,
                        tint: accent,
                        borderRadius: AppRadius.field,
                        child: SizedBox.square(
                          dimension: 52,
                          child: Center(
                            child: Text(
                              app.iconEmoji,
                              textScaler: TextScaler.noScaling,
                              style: AppText.sans(
                                26,
                                FontWeight.w400,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        app.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppText.sans(
                          13,
                          FontWeight.w500,
                          height: 1.2,
                        ).copyWith(color: colors.ink),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
