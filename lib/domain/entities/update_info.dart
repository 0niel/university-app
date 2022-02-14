import 'package:equatable/equatable.dart';

class UpdateInfo extends Equatable {
  final String title;
  final String? description;
  final String text;
  final String appVersion;
  final int buildNumber;

  const UpdateInfo({
    required this.title,
    required this.description,
    required this.text,
    required this.appVersion,
    required this.buildNumber,
  });

  @override
  List<Object> get props => [title, text, appVersion, buildNumber];
}
