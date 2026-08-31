enum EventCategory {
  all('all'),
  career('career'),
  sport('sport'),
  art('art'),
  science('sci'),
  other('other');

  const EventCategory(this.wireName);

  final String wireName;

  static EventCategory fromWireName(String value) {
    for (final category in values) {
      if (category.wireName == value) return category;
    }
    return other;
  }
}
