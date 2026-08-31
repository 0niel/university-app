part of '../changes_page.dart';

class _ChangeTimelineRowSkeleton extends StatelessWidget {
  const _ChangeTimelineRowSkeleton({this.last = false});

  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .only(bottom: last ? 4 : 10),
      child: const NinjaScheduleSurface(
        child: Row(
          crossAxisAlignment: .start,
          spacing: 12,
          children: [
            NinjaSkeleton.avatar(),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 6,
                children: [
                  NinjaSkeleton.bar(height: 14, widthFactor: 0.7),
                  NinjaSkeleton.bar(height: 11, widthFactor: 0.5),
                  SizedBox(height: 2),
                  NinjaSkeleton(
                    width: 72,
                    height: 18,
                    radius: NinjaRadius.pill,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
