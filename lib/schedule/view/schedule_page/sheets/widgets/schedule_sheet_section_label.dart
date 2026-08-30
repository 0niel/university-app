import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ScheduleSheetSectionLabel extends StatelessWidget {
  const ScheduleSheetSectionLabel(this.label, {super.key, this.first = false});

  final String label;
  final bool first;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .only(top: first ? 20 : 24, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: NinjaText.microLabel.copyWith(color: context.ninja.muted),
      ),
    );
  }
}
