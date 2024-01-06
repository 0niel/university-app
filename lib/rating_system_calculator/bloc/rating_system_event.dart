part of 'rating_system_bloc.dart';

abstract class RatingSystemEvent extends Equatable {
  const RatingSystemEvent();
}

class UpdateSubjectsByCurrentSchedule extends RatingSystemEvent {
  const UpdateSubjectsByCurrentSchedule({
    required this.group,
    required this.subjects,
  });

  final Group group;
  final List<Subject> subjects;

  @override
  List<Object> get props => [group, subjects];
}
