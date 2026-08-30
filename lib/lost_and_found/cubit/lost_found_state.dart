import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/lost_and_found/cubit/lost_found_status.dart';

part 'lost_found_state.freezed.dart';

@freezed
abstract class LostFoundState with _$LostFoundState {
  const factory LostFoundState({
    @Default(LostFoundStatus.initial) LostFoundStatus status,
    @Default(<LostFoundItem>[]) List<LostFoundItem> items,
    @Default(LostFoundItemStatus.found) LostFoundItemStatus tab,
    @Default('all') String category,
    @Default('') String query,
    @Default(false) bool isSearching,
    @Default(<String>{}) Set<String> pendingStatusIds,
    @Default(<String>{}) Set<String> pendingDeleteIds,
    @Default(false) bool isCreating,
    @Default(0) int cleanupWarningRevision,
  }) = _LostFoundState;

  const LostFoundState._();

  bool get isBusy =>
      isCreating || pendingStatusIds.isNotEmpty || pendingDeleteIds.isNotEmpty;

  List<LostFoundItem> get filteredItems {
    final normalizedQuery = query.trim().toLowerCase();
    return [
      for (final item in items)
        if (item.status == tab &&
            (category == 'all' || item.category == category) &&
            (normalizedQuery.isEmpty ||
                item.itemName.toLowerCase().contains(normalizedQuery) ||
                (item.description ?? '').toLowerCase().contains(
                  normalizedQuery,
                )))
          item,
    ];
  }

  int countFor(LostFoundItemStatus status) =>
      items.where((item) => item.status == status).length;
}
