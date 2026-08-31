part of 'category_feed_loader_item.dart';

class _Bounded extends StatelessWidget {
  const _Bounded({required this.child, this.isLast = false});

  final Widget child;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? AppSpacing.xlg : AppSpacing.gap,
      ),
      child: child,
    );
  }
}
