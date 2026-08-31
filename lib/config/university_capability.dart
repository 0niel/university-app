enum UniversityCapability {
  campusMap('campus_map'),
  nfcPass('nfc_pass'),
  virtualTour('virtual_tour');

  const UniversityCapability(this.wireName);

  final String wireName;

  static Set<UniversityCapability> parseCsv(String value) {
    final values = value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
    final capabilities = <UniversityCapability>{};
    for (final wireName in values) {
      UniversityCapability? capability;
      for (final item in UniversityCapability.values) {
        if (item.wireName == wireName) {
          capability = item;
          break;
        }
      }
      if (capability == null || !capabilities.add(capability)) {
        throw ArgumentError.value(value, 'APP_ENABLED_CAPABILITIES');
      }
    }
    return Set.unmodifiable(capabilities);
  }
}
