import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ToolsState extends Equatable {
  const ToolsState({
    this.marks = const {},
    this.grants = const {},
    this.credits = const {},
    this.creditTarget = 60,
  });

  final Map<String, int> marks;
  final Map<String, int> grants;
  final Map<String, int> credits;
  final int creditTarget;

  @override
  List<Object> get props => [marks, grants, credits, creditTarget];
}

class ToolsCubit extends HydratedCubit<ToolsState> {
  ToolsCubit() : super(const ToolsState());

  void cycleMark(String subject) {
    if (subject.trim().isEmpty) return;
    final value = state.marks[subject];
    emit(
      ToolsState(
        marks: {
          ...state.marks,
          subject: value == null || value == 5 ? 3 : value + 1,
        },
        grants: state.grants,
        credits: state.credits,
        creditTarget: state.creditTarget,
      ),
    );
  }

  void setGrant(String kind, int value) {
    if (value < 0 || value > 1000000) return;
    emit(
      ToolsState(
        marks: state.marks,
        grants: {...state.grants, kind: value},
        credits: state.credits,
        creditTarget: state.creditTarget,
      ),
    );
  }

  void setCredits(String subject, int value) {
    if (subject.trim().isEmpty || value < 0 || value > 120) return;
    emit(
      ToolsState(
        marks: state.marks,
        grants: state.grants,
        credits: {...state.credits, subject: value},
        creditTarget: state.creditTarget,
      ),
    );
  }

  void setCreditTarget(int value) {
    if (value < 1 || value > 600) return;
    emit(
      ToolsState(
        marks: state.marks,
        grants: state.grants,
        credits: state.credits,
        creditTarget: value,
      ),
    );
  }

  @override
  ToolsState? fromJson(Map<String, dynamic> json) {
    Map<String, int> values(String name, int minimum, int maximum) {
      final raw = json[name];
      if (raw is! Map) return const {};
      return {
        for (final entry in raw.entries)
          if (entry.key is String &&
              entry.value is int &&
              (entry.value as int) >= minimum &&
              (entry.value as int) <= maximum)
            entry.key as String: entry.value as int,
      };
    }

    final target = json['creditTarget'];
    return ToolsState(
      marks: values('marks', 3, 5),
      grants: values('grants', 0, 1000000),
      credits: values('credits', 0, 120),
      creditTarget: target is int && target > 0 && target <= 600 ? target : 60,
    );
  }

  @override
  Map<String, dynamic> toJson(ToolsState state) => {
    'marks': state.marks,
    'grants': state.grants,
    'credits': state.credits,
    'creditTarget': state.creditTarget,
  };
}
