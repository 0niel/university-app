part of 'discourse_bloc.dart';

enum DiscourseStatus { initial, loading, loaded, failure }

class DiscourseState extends Equatable {
  const DiscourseState({required this.topTopics, required this.status});

  const DiscourseState.initial() : this(topTopics: null, status: DiscourseStatus.initial);

  final Top? topTopics;
  final DiscourseStatus status;

  @override
  List<Object?> get props => [topTopics, status];

  DiscourseState copyWith({Top? topTopics, DiscourseStatus? status}) {
    return DiscourseState(topTopics: topTopics ?? this.topTopics, status: status ?? this.status);
  }
}
