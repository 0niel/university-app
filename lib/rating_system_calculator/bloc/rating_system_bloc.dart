import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rtu_mirea_app/rating_system_calculator/models/models.dart';

part 'rating_system_bloc.g.dart';
part 'rating_system_event.dart';
part 'rating_system_state.dart';

typedef Group = String;

class RatingSystemBloc extends HydratedBloc<RatingSystemEvent, RatingSystemState> {
  RatingSystemBloc() : super(const RatingSystemState()) {
    on<UpdateSubjectsByCurrentSchedule>(_onUpdateSubjectsByCurrentSchedule);
  }

  void _onUpdateSubjectsByCurrentSchedule(
    UpdateSubjectsByCurrentSchedule event,
    Emitter<RatingSystemState> emit,
  ) {
    final actualSubjects = event.subjects;

    final newSubjects = <(Group, Subject)>[];

    for (final actualSubject in actualSubjects) {
      final index = state.subjects.indexWhere(
        (element) => element.$2.name == actualSubject.name && element.$1 == event.group,
      );

      if (index == -1) {
        newSubjects.add(
          (event.group, actualSubject),
        );
      } else {
        final subject = state.subjects[index];

        if (actualSubject.mainScore == 0 && actualSubject.additionalScore == 0 && actualSubject.classScore == 0) {
          state.subjects.removeAt(index);
        } else {
          newSubjects.add(subject);
        }
      }
    }

    emit(
      state.copyWith(
        subjects: newSubjects,
      ),
    );
  }

  @override
  RatingSystemState? fromJson(Map<String, dynamic> json) => RatingSystemState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(RatingSystemState state) => state.toJson();
}
