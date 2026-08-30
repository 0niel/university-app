part of '../analytics_page.dart';

class _AnalyticsSkeleton extends StatelessWidget {
  const _AnalyticsSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: .stretch,
    children: [
      Row(
        children: [
          Expanded(
            child: NinjaSkeleton(height: 96, radius: NinjaRadius.card),
          ),
          SizedBox(width: 10),
          Expanded(
            child: NinjaSkeleton(height: 96, radius: NinjaRadius.card),
          ),
        ],
      ),
      SizedBox(height: 10),
      NinjaSkeleton(height: 232, radius: NinjaRadius.card),
      SizedBox(height: 10),
      NinjaSkeleton(height: 148, radius: NinjaRadius.card),
      SizedBox(height: 10),
      NinjaSkeleton(height: 76, radius: NinjaRadius.card),
      SizedBox(height: 10),
      NinjaSkeleton(height: 76, radius: NinjaRadius.card),
    ],
  );
}
