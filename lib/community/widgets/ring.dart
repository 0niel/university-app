part of 'team_avatar_stack.dart';

class _Ring extends StatelessWidget {
  const _Ring({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(color: color, shape: .circle),
    child: Padding(padding: const .all(2), child: child),
  );
}
