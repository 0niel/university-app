import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/config/marketplace_category.dart';

class MarketplaceCategoryPicker extends StatelessWidget {
  const MarketplaceCategoryPicker({
    required this.keys,
    required this.selectedKey,
    required this.onChanged,
    super.key,
  });

  final List<String> keys;
  final String selectedKey;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final callback = onChanged;
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final key in keys)
          AppChip(
            label: MarketplaceCategories.label(context.l10n, key),
            selected: selectedKey == key,
            enabled: callback != null,
            onTap: callback == null ? null : () => callback(key),
          ),
      ],
    );
  }
}
