part of 'app_bloc.dart';

class AppState extends Equatable {
  final bool isAmoled;
  final int? discoursePostIdToOpen;

  const AppState({this.isAmoled = false, this.discoursePostIdToOpen});

  AppState copyWith({bool? isAmoled, int? discoursePostIdToOpen}) {
    return AppState(
      isAmoled: isAmoled ?? this.isAmoled,
      discoursePostIdToOpen: discoursePostIdToOpen ?? this.discoursePostIdToOpen,
    );
  }

  @override
  List<Object?> get props => [isAmoled, discoursePostIdToOpen];
}
