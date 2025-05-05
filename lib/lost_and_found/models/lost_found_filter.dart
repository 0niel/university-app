import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:university_app_server_api/client.dart';

enum LostFoundSortOption { newest, oldest, alphabetical }

class LostFoundFilter {
  final LostFoundItemStatus? status;
  final String? searchQuery;
  final LostFoundSortOption sortOption;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final bool onlyWithImages;

  const LostFoundFilter({
    this.status,
    this.searchQuery,
    this.sortOption = LostFoundSortOption.newest,
    this.dateFrom,
    this.dateTo,
    this.onlyWithImages = false,
  });

  LostFoundFilter copyWith({
    LostFoundItemStatus? status,
    bool clearStatus = false,
    String? searchQuery,
    bool clearSearchQuery = false,
    LostFoundSortOption? sortOption,
    DateTime? dateFrom,
    bool clearDateFrom = false,
    DateTime? dateTo,
    bool clearDateTo = false,
    bool? onlyWithImages,
  }) {
    return LostFoundFilter(
      status: clearStatus ? null : status ?? this.status,
      searchQuery: clearSearchQuery ? null : searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      dateFrom: clearDateFrom ? null : dateFrom ?? this.dateFrom,
      dateTo: clearDateTo ? null : dateTo ?? this.dateTo,
      onlyWithImages: onlyWithImages ?? this.onlyWithImages,
    );
  }

  List<LostFoundItem> apply(List<LostFoundItem> items) {
    var result = List<LostFoundItem>.from(items);

    // Apply status filter
    if (status != null) {
      result = result.where((item) => item.status == status).toList();
    }

    // Apply search filter
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      result =
          result.where((item) {
            return item.itemName.toLowerCase().contains(query) ||
                (item.description?.toLowerCase().contains(query) ?? false);
          }).toList();
    }

    // Apply date filters
    if (dateFrom != null) {
      result = result.where((item) => item.createdAt.isAfter(dateFrom!)).toList();
    }

    if (dateTo != null) {
      result = result.where((item) => item.createdAt.isBefore(dateTo!.add(Duration(days: 1)))).toList();
    }

    // Apply image filter
    if (onlyWithImages) {
      result = result.where((item) => item.images != null && item.images!.isNotEmpty).toList();
    }

    // Apply sorting
    switch (sortOption) {
      case LostFoundSortOption.newest:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case LostFoundSortOption.oldest:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case LostFoundSortOption.alphabetical:
        result.sort((a, b) => a.itemName.toLowerCase().compareTo(b.itemName.toLowerCase()));
        break;
    }

    return result;
  }
}
