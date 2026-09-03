import 'package:app_ui/src/widgets/app_badge.dart';
import 'package:flutter/widgets.dart';

class AppLiveBadge extends StatelessWidget {
  const AppLiveBadge({super.key, this.label = 'Сейчас'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AppBadge(label: label, tone: AppBadgeTone.accent, dot: true);
  }
}
