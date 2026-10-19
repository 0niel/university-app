class MapDataException implements Exception {
  const MapDataException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}
