part of 'profile_page.dart';

class _ProfileWidth extends StatelessWidget {
  const _ProfileWidth({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 620),
      child: child,
    ),
  );
}
