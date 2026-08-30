part of 'free_rooms_view.dart';

class _FreeRoomsListSkeleton extends StatelessWidget {
  const _FreeRoomsListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      label: context.l10n.loadingContent,
      child: ExcludeSemantics(
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const .fromLTRB(
            NinjaMetrics.screenPadding,
            0,
            NinjaMetrics.screenPadding,
            40,
          ),
          itemCount: 6,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) => const _FreeRoomRowSkeleton(),
        ),
      ),
    );
  }
}
