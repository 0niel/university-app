final class Period {
  const Period({
    required this.yearStart,
    required this.yearEnd,
    required this.semester,
  }) : assert(semester == 1 || semester == 2, 'semester must be 1 or 2');

  final int yearStart;
  final int yearEnd;
  final int semester;
}
