import 'package:flutter/widgets.dart';

class MiniAppTemplate {
  const MiniAppTemplate({required this.nameBuilder, required this.screens});

  final String Function(BuildContext context) nameBuilder;
  final List<(String, String)> screens;
}
