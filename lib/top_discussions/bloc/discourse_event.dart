part of 'discourse_bloc.dart';

abstract class DiscourseEvent extends Equatable {
  const DiscourseEvent();
}

class DiscourseTopTopicsRequested extends DiscourseEvent {
  const DiscourseTopTopicsRequested();

  @override
  List<Object?> get props => [];
}
