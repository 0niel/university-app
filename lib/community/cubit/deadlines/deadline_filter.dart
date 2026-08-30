enum DeadlineFilter {
  all('all'),
  hot('hot'),
  mine('me'),
  group('group'),
  done('done');

  const DeadlineFilter(this.wireName);

  final String wireName;

  static DeadlineFilter fromWireName(String value) {
    for (final filter in values) {
      if (filter.wireName == value) return filter;
    }
    return all;
  }
}
