import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppListGroup(children: children);
  }
}
