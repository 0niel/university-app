import 'package:flutter/cupertino.dart';

/// Widget to make content always be above keyboard
class KeyboardPositioned extends StatelessWidget {
  const KeyboardPositioned({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 0,
          right: 0,
          child: child,
        )
      ],
    );
  }
}
