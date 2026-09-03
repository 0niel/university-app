import 'package:flutter/widgets.dart';

class KeyboardPositioned extends StatelessWidget {
  const KeyboardPositioned({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
          left: 0,
          right: 0,
          child: child,
        ),
      ],
    );
  }
}
