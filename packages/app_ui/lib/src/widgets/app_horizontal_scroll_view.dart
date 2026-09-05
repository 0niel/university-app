import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class AppHorizontalScrollView extends StatelessWidget {
  const AppHorizontalScrollView({
    required this.child,
    this.controller,
    this.padding,
    this.clipBehavior = Clip.hardEdge,
    super.key,
  });

  final Widget child;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final behavior = ScrollConfiguration.of(context);
    return ScrollConfiguration(
      behavior: behavior.copyWith(
        dragDevices: {...behavior.dragDevices, PointerDeviceKind.mouse},
      ),
      child: SingleChildScrollView(
        controller: controller,
        padding: padding,
        clipBehavior: clipBehavior,
        scrollDirection: Axis.horizontal,
        child: child,
      ),
    );
  }
}
