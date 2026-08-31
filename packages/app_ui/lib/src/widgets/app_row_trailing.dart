import 'package:flutter/widgets.dart';

class AppRowTrailing extends StatelessWidget {
  const AppRowTrailing({
    required this.child,
    super.key,
    this.maxWidthFactor = 0.42,
  }) : assert(
          maxWidthFactor > 0 && maxWidthFactor <= 1,
          'The cap must be a fraction of the screen width.',
        );

  final Widget child;
  final double maxWidthFactor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.widthOf(context) * maxWidthFactor,
      ),
      child: child,
    );
  }
}
