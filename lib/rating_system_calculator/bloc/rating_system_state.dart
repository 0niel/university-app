part of 'rating_system_bloc.dart';

@JsonSerializable()
class RatingSystemState extends Equatable {
  const RatingSystemState({
    this.subjects = const [],
  });

  @SubjectsConverter()
  final List<(Group, Subject)> subjects;

  factory RatingSystemState.fromJson(Map<String, dynamic> json) => _$RatingSystemStateFromJson(json);

  Map<String, dynamic> toJson() => _$RatingSystemStateToJson(this);

  RatingSystemState copyWith({
    List<(Group, Subject)>? subjects,
  }) {
    return RatingSystemState(
      subjects: subjects ?? this.subjects,
    );
  }

  @override
  List<Object?> get props => [
        subjects,
      ];
}

class SubjectsConverter implements JsonConverter<List<(Group, Subject)>, List<dynamic>> {
  const SubjectsConverter();

  @override
  List<(Group, Subject)> fromJson(List<dynamic> json) {
    return json
        .map(
          (dynamic e) => (e['group'] as String, Subject.fromJson(e)),
        )
        .toList();
  }

  @override
  List<dynamic> toJson(List<(Group, Subject)> object) {
    return object
        .map(
          (e) => {
            'group': e.$1,
            ...e.$2.toJson(),
          },
        )
        .toList();
  }
}
