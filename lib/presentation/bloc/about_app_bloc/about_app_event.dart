part of 'about_app_bloc.dart';

abstract class AboutAppEvent extends Equatable {
  const AboutAppEvent();

  @override
  List<Object> get props => [];
}

class AboutAppGetMembers extends AboutAppEvent {}
