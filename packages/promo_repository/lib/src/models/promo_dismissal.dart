class PromoDismissal {
  const PromoDismissal({
    required this.bannerId,
    required this.version,
    this.hidden = false,
    this.snoozedUntil,
  });

  factory PromoDismissal.fromJson(Map<String, dynamic> json) => PromoDismissal(
    bannerId: json['bannerId'] as String,
    version: json['version'] as int,
    hidden: json['hidden'] as bool? ?? false,
    snoozedUntil: DateTime.tryParse(json['snoozedUntil'] as String? ?? ''),
  );

  final String bannerId;
  final int version;
  final bool hidden;
  final DateTime? snoozedUntil;

  String get key => '$bannerId:$version';
}
