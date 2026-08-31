part of 'polls_view.dart';

class _PollsSkeleton extends StatelessWidget {
  const _PollsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      label: context.l10n.loadingContent,
      child: ExcludeSemantics(
        child: NinjaSkeletonGroup(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
            itemCount: 4,
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _PollSkeletonCard(
                questionLines: index.isEven ? 2 : 1,
                optionCount: index.isEven ? 3 : 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
