import 'package:lost_and_found_repository/lost_and_found_repository.dart';

enum LostFoundTab {
  all,
  found,
  lost;

  bool matches(LostFoundItem item) => switch (this) {
    .all => true,
    .found => item.status == .found,
    .lost => item.status == .lost,
  };
}
