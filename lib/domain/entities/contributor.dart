import 'package:equatable/equatable.dart';

class Contributor extends Equatable {
  const Contributor({
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.contributions,
  });

  final String login;
  final String avatarUrl;
  final String htmlUrl;
  final int contributions;

  @override
  List<Object?> get props => [login, avatarUrl, htmlUrl, contributions];
}
