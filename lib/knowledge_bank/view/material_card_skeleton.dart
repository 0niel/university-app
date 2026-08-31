part of 'knowledge_bank_list_skeleton.dart';

class _MaterialCardSkeleton extends StatelessWidget {
  const _MaterialCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.ninja.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NinjaSkeleton(width: 44, height: 44, radius: NinjaRadius.button),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NinjaSkeleton.bar(widthFactor: .72, height: 16),
                  SizedBox(height: 8),
                  NinjaSkeleton.bar(widthFactor: .88, height: 11),
                  SizedBox(height: 12),
                  NinjaSkeleton.bar(widthFactor: .34, height: 10),
                ],
              ),
            ),
            SizedBox(width: 12),
            NinjaSkeleton(width: 64, height: 32, radius: NinjaRadius.pill),
          ],
        ),
      ),
    );
  }
}
