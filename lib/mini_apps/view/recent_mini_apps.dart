part of 'mini_apps_page.dart';

class _RecentMiniApps extends StatelessWidget {
  const _RecentMiniApps({required this.apps, required this.onOpen});

  final List<MiniApp> apps;
  final ValueChanged<MiniApp> onOpen;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return SizedBox(
      height: textScale >= 1.6 ? 138 : 102,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
        ),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: apps.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.lg),
        itemBuilder: (context, index) {
          final app = apps[index];
          return SizedBox(
            width: textScale >= 1.6 ? 108 : 76,
            child: AppServiceTile(
              emoji: app.iconEmoji,
              color: context.colors.accent,
              label: app.name,
              size: textScale >= 1.6 ? 58 : 52,
              onTap: () => onOpen(app),
            ),
          );
        },
      ),
    );
  }
}
