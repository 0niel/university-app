import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ExamTopic extends Equatable {
  const ExamTopic({required this.title, this.done = false});

  final String title;
  final bool done;

  @override
  List<Object> get props => [title, done];
}

class ExamTopicsState extends Equatable {
  const ExamTopicsState({this.topics = const {}, this.revisions = const {}});

  final Map<String, List<ExamTopic>> topics;
  final Map<String, int> revisions;

  List<ExamTopic> forExam(String key) => topics[key] ?? const [];

  double? readiness(String key) {
    final list = forExam(key);
    return list.isEmpty
        ? null
        : list.where((topic) => topic.done).length / list.length;
  }

  List<ExamTopic> plan(String key) {
    final remaining = forExam(key).where((topic) => !topic.done).toList();
    if (remaining.isEmpty) return remaining;
    final offset = (revisions[key] ?? 0) % remaining.length;
    return [...remaining.skip(offset), ...remaining.take(offset)];
  }

  @override
  List<Object> get props => [topics, revisions];
}

class ExamTopicsCubit extends HydratedCubit<ExamTopicsState> {
  ExamTopicsCubit() : super(const ExamTopicsState());

  bool addTopic(String key, String title) {
    final text = title.trim();
    final topics = state.forExam(key);
    if (text.isEmpty ||
        text.length > 150 ||
        topics.any(
          (topic) => topic.title.toLowerCase() == text.toLowerCase(),
        )) {
      return false;
    }
    _set(key, [...topics, ExamTopic(title: text)]);
    return true;
  }

  void toggle(String key, int index) {
    final topics = state.forExam(key);
    if (index < 0 || index >= topics.length) return;
    _set(key, [
      for (final (i, topic) in topics.indexed)
        i == index ? ExamTopic(title: topic.title, done: !topic.done) : topic,
    ]);
  }

  void remove(String key, int index) {
    _set(key, [
      for (final (i, topic) in state.forExam(key).indexed)
        if (i != index) topic,
    ]);
  }

  void rebuild(String key) => emit(
    ExamTopicsState(
      topics: state.topics,
      revisions: {...state.revisions, key: (state.revisions[key] ?? 0) + 1},
    ),
  );

  void _set(String key, List<ExamTopic> topics) => emit(
    ExamTopicsState(
      topics: {...state.topics, key: topics},
      revisions: state.revisions,
    ),
  );

  @override
  ExamTopicsState? fromJson(Map<String, dynamic> json) {
    final raw = json['topics'];
    final revisions = json['revisions'];
    return ExamTopicsState(
      topics: raw is Map
          ? {
              for (final entry in raw.entries)
                if (entry.key is String && entry.value is List)
                  entry.key as String: [
                    for (final item in entry.value as List)
                      if (item is Map &&
                          item['title'] is String &&
                          (item['title'] as String).trim().isNotEmpty)
                        ExamTopic(
                          title: item['title'] as String,
                          done: item['done'] == true,
                        ),
                  ],
            }
          : const {},
      revisions: revisions is Map
          ? {
              for (final entry in revisions.entries)
                if (entry.key is String &&
                    entry.value is int &&
                    (entry.value as int) >= 0)
                  entry.key as String: entry.value as int,
            }
          : const {},
    );
  }

  @override
  Map<String, dynamic> toJson(ExamTopicsState state) => {
    'topics': {
      for (final entry in state.topics.entries)
        entry.key: [
          for (final topic in entry.value)
            {'title': topic.title, 'done': topic.done},
        ],
    },
    'revisions': state.revisions,
  };
}
