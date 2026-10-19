import 'package:flutter/widgets.dart';

class AppHeaderTextAction {
  const AppHeaderTextAction({
    required this.label,
    required this.onTap,
    this.key,
  });

  final String label;
  final VoidCallback? onTap;
  final Key? key;
}
