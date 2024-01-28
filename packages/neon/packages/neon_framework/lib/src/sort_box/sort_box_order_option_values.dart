import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/models/label_builder.dart';
import 'package:sort_box/sort_box.dart';

/// Sort box order labels used in an `SelectOption`.
final sortBoxOrderOptionValues = <SortBoxOrder, LabelBuilder>{
  SortBoxOrder.ascending: (context) => NeonLocalizations.of(context).optionsSortOrderAscending,
  SortBoxOrder.descending: (context) => NeonLocalizations.of(context).optionsSortOrderDescending,
};
