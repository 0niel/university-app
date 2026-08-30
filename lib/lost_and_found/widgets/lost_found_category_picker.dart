import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/config/lost_found_categories.dart';

class LostFoundCategoryPicker extends StatelessWidget {
  const LostFoundCategoryPicker({
    required this.keys,
    required this.value,
    required this.onChanged,
    this.labelBuilder,
    this.padding = const EdgeInsets.symmetric(
      horizontal: NinjaMetrics.screenPadding,
    ),
    super.key,
  });

  final List<String> keys;
  final String value;
  final ValueChanged<String> onChanged;
  final String Function(String key)? labelBuilder;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return NinjaChipRow(
      padding: padding,
      children: [
        for (final key in keys)
          NinjaChip(
            label:
                labelBuilder?.call(key) ??
                LostFoundCategories.label(
                  l10n,
                  key,
                ),
            selected: value == key,
            onTap: () => onChanged(key),
          ),
      ],
    );
  }
}
