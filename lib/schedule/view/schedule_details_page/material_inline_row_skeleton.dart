part of '../schedule_details_page.dart';

class _MaterialInlineRowSkeleton extends StatelessWidget {
  const _MaterialInlineRowSkeleton();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: .symmetric(
      horizontal: NinjaMetrics.screenPadding,
      vertical: 12,
    ),
    child: Row(
      children: [
        NinjaSkeleton.avatar(size: 40),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              NinjaSkeleton.bar(widthFactor: 0.7),
              SizedBox(height: 6),
              NinjaSkeleton.bar(height: 11, widthFactor: 0.45),
            ],
          ),
        ),
      ],
    ),
  );
}
