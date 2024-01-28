import 'package:flutter/material.dart';
import 'package:neon_framework/src/utils/adaptive.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// A widget showing a list of settings widgets.
@visibleForTesting
class SettingsList extends StatelessWidget {
  /// Creates a new settings list.
  const SettingsList({
    required this.categories,
    this.initialCategoryKey,
    super.key,
  });

  /// The categories of this settings screen.
  final List<Widget> categories;

  /// The initial category to scroll to.
  final String? initialCategoryKey;

  int? _getIndex(String? initialCategory) {
    if (initialCategory == null) {
      return null;
    }

    final key = Key(initialCategory);
    final index = categories.indexWhere((category) => category.key == key);

    return index != -1 ? index : null;
  }

  @override
  Widget build(BuildContext context) {
    final hasPadding = !isCupertino(context);

    return ScrollablePositionedList.builder(
      padding: hasPadding ? const EdgeInsets.symmetric(horizontal: 20) : null,
      itemCount: categories.length,
      initialScrollIndex: _getIndex(initialCategoryKey) ?? 0,
      itemBuilder: (context, index) => categories[index],
    );
  }
}
