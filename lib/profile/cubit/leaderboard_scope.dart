part of 'ninja_path_cubit.dart';

enum LeaderboardScope {
  group('group'),
  course('course'),
  faculty('faculty'),
  all('all');

  const LeaderboardScope(this.value);

  final String value;
}
