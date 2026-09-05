part of 'lost_found_item_sheet.dart';

class _InfoSurface extends StatelessWidget {
  const _InfoSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: context.colors.surface2,
      child: child,
    );
  }
}
