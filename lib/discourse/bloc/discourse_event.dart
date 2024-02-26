part of 'discourse_bloc.dart';

abstract class DiscourseEvent extends Equatable {
  const DiscourseEvent();
}

class DiscourseTopTopicsLoadRequest extends DiscourseEvent {
  const DiscourseTopTopicsLoadRequest();

  @override
  List<Object?> get props => [];
}
