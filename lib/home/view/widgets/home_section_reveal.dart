import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class HomeSectionReveal extends StatelessWidget {
  const HomeSectionReveal({required this.child, this.order = 0, super.key});

  final Widget child;
  final int order;

  @override
  Widget build(BuildContext context) {
    final duration = NinjaMotion.of(context, const Duration(milliseconds: 700));
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Interval(
        (order * .055).clamp(0, .35),
        1,
        curve: Curves.easeOutCubic,
      ),
      child: child,
      builder: (context, value, content) => Transform.translate(
        offset: duration == Duration.zero
            ? Offset.zero
            : Offset(0, 18 * (1 - value)),
        child: content,
      ),
    );
  }
}
