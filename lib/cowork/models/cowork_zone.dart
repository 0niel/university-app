enum CoworkZone {
  quiet('Т', 24),
  common('О', 24),
  meeting('П', 10);

  const CoworkZone(this.prefix, this.capacity);

  static const gridSize = 24;

  final String prefix;
  final int capacity;

  String seatId(int number) => '$prefix$number';

  static int get totalCapacity =>
      values.fold(0, (sum, zone) => sum + zone.capacity);
}
