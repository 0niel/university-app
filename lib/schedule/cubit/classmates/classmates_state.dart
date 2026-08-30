part of 'classmates_cubit.dart';

@freezed
abstract class ClassmatesState with _$ClassmatesState {
  const factory ClassmatesState({
    @Default(<Friend>[]) List<Friend> classmates,
    @Default('') String group,
    @Default(false) bool loading,
  }) = _ClassmatesState;

  const ClassmatesState._();

  List<String> get firstNames => [
    for (final friend in classmates) _firstName(friend.fullName),
  ];

  static String _firstName(String fullName) {
    final firstSpace = fullName.indexOf(' ');
    return firstSpace < 0 ? fullName : fullName.substring(0, firstSpace);
  }
}
