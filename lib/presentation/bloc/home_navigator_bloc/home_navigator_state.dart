part of 'home_navigator_bloc.dart';

abstract class HomeNavigatorState extends Equatable {
  const HomeNavigatorState();

  @override
  List<Object> get props => [];
}

class HomeNavigatorInitial extends HomeNavigatorState {}

class SchedulePage extends HomeNavigatorState {}

class SettingsPage extends HomeNavigatorState {}
