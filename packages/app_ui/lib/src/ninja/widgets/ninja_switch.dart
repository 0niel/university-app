import 'package:app_ui/src/widgets/app_toggle.dart';
import 'package:flutter/material.dart';

class NinjaSwitch extends StatelessWidget {
  const NinjaSwitch({
    required this.value,
    super.key,
    this.onChanged,
    this.label,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) =>
      AppSwitch(value: value, onChanged: onChanged, label: label);
}
