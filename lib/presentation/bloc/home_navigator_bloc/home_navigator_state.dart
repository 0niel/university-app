part of 'home_navigator_bloc.dart';

abstract class HomeNavigatorState extends Equatable {
  const HomeNavigatorState();

  Widget get screen;

  @override
  List<Object> get props => [];
}

class SchedulePage extends HomeNavigatorState {
  final _screen = ScheduleScreen();

  @override
  Widget get screen => _screen;

  @override
  List<Object> get props => [_screen];
}

class SettingsPage extends HomeNavigatorState {
  final _screen = SettingsScreen();

  @override
  Widget get screen => _screen;

  @override
  List<Object> get props => [_screen];
}
