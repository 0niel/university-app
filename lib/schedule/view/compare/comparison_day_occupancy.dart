class ComparisonDayOccupancy {
  const ComparisonDayOccupancy({
    required this.ranges,
    required this.uncertainFrom,
  });

  final List<(int, int)> ranges;
  final List<int> uncertainFrom;

  bool get hasEntries => ranges.isNotEmpty || uncertainFrom.isNotEmpty;

  bool isBusy(int start, int end) =>
      ranges.any((range) => range.$1 < end && range.$2 > start);

  bool isUncertain(int _, int end) =>
      uncertainFrom.any((minute) => minute < end);

  bool isFree(int start, int end) =>
      !isBusy(start, end) && !isUncertain(start, end);
}
