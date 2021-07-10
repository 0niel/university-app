part of 'home_navigator_bloc.dart';

abstract class HomeNavigatorEvent extends Equatable {
  const HomeNavigatorEvent();

  @override
  List<Object> get props => [];
}

class ChangeScreen extends HomeNavigatorEvent {
  final String routeName;

  ChangeScreen(this.routeName);

  @override
  List<Object> get props => [routeName];
}
