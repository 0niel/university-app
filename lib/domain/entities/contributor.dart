import 'package:equatable/equatable.dart';

class Contributor extends Equatable {
  const Contributor({
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
  });

  final String login;
  final String avatarUrl;
  final String htmlUrl;

  @override
  List<Object?> get props => [login, avatarUrl, htmlUrl];
}
