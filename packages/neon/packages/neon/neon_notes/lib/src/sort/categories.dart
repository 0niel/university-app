import 'package:neon_framework/sort_box.dart';
import 'package:neon_notes/src/options.dart';

final categoriesSortBox = SortBox<CategoriesSortProperty, NoteCategory>(
  properties: {
    CategoriesSortProperty.alphabetical: (category) => category.name.toLowerCase(),
    CategoriesSortProperty.notesCount: (category) => category.count,
  },
  boxes: const {
    CategoriesSortProperty.notesCount: {
      (property: CategoriesSortProperty.alphabetical, order: SortBoxOrder.ascending),
    },
  },
);

class NoteCategory {
  NoteCategory(
    this.name,
    this.count,
  );

  final String name;
  final int count;
}
