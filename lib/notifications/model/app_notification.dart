import 'package:equatable/equatable.dart';

enum AppNotificationKind {
  warn,
  danger,
  accent,
  lecture,
  muted;

  static AppNotificationKind parse(String? value) => values.firstWhere(
    (kind) => kind.name == value,
    orElse: () => AppNotificationKind.accent,
  );
}

class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.kind,
    required this.title,
    required this.createdAt,
    this.subtitle,
    this.route,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'].toString(),
      kind: AppNotificationKind.parse(json['kind']?.toString()),
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      route: json['route']?.toString(),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  final String id;
  final AppNotificationKind kind;
  final String title;
  final String? subtitle;
  final String? route;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'subtitle': subtitle,
    'route': route,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, kind, title, subtitle, route, createdAt];
}
