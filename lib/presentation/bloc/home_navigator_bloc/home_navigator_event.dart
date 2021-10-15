part of 'home_navigator_bloc.dart';

abstract class HomeNavigatorEvent extends Equatable {
  const HomeNavigatorEvent();

  @override
  List<Object> get props => [];
}

class ChangeScreen extends HomeNavigatorEvent {
  final String routeName;
  final int pageIndex;

  const ChangeScreen({required this.routeName, required this.pageIndex});

  @override
  List<Object> get props => [routeName, pageIndex];
}
