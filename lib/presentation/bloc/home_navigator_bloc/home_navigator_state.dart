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

class MapPage extends HomeNavigatorState {
  final _screen = MapScreen();

  @override
  Widget get screen => _screen;

  @override
  List<Object> get props => [_screen];
}

class ProfilePage extends HomeNavigatorState {
  final _screen = ProfileScreen();

  @override
  Widget get screen => _screen;

  @override
  List<Object> get props => [_screen];
}

class NewsPage extends HomeNavigatorState {
  final _screen = NewsScreen();

  @override
  Widget get screen => _screen;

  @override
  List<Object> get props => [_screen];
}
