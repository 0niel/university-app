import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ProfileExtrasState extends Equatable {
  const ProfileExtrasState({
    this.about = '',
    this.telegram = '',
    this.showCancelled = true,
    this.onlySubgroup = false,
    this.notifyLessons = true,
    this.notifyDeadlines = true,
    this.notifyNews = true,
  });

  factory ProfileExtrasState.fromJson(Map<String, dynamic> json) {
    bool flag(String key, {required bool fallback}) =>
        json[key] is bool ? json[key] as bool : fallback;
    return ProfileExtrasState(
      about: json['about'] as String? ?? '',
      telegram: json['telegram'] as String? ?? '',
      showCancelled: flag('showCancelled', fallback: true),
      onlySubgroup: flag('onlySubgroup', fallback: false),
      notifyLessons: flag('notifyLessons', fallback: true),
      notifyDeadlines: flag('notifyDeadlines', fallback: true),
      notifyNews: flag('notifyNews', fallback: true),
    );
  }

  final String about;
  final String telegram;
  final bool showCancelled;
  final bool onlySubgroup;
  final bool notifyLessons;
  final bool notifyDeadlines;
  final bool notifyNews;

  ProfileExtrasState copyWith({
    String? about,
    String? telegram,
    bool? showCancelled,
    bool? onlySubgroup,
    bool? notifyLessons,
    bool? notifyDeadlines,
    bool? notifyNews,
  }) {
    return ProfileExtrasState(
      about: about ?? this.about,
      telegram: telegram ?? this.telegram,
      showCancelled: showCancelled ?? this.showCancelled,
      onlySubgroup: onlySubgroup ?? this.onlySubgroup,
      notifyLessons: notifyLessons ?? this.notifyLessons,
      notifyDeadlines: notifyDeadlines ?? this.notifyDeadlines,
      notifyNews: notifyNews ?? this.notifyNews,
    );
  }

  Map<String, dynamic> toJson() => {
    'about': about,
    'telegram': telegram,
    'showCancelled': showCancelled,
    'onlySubgroup': onlySubgroup,
    'notifyLessons': notifyLessons,
    'notifyDeadlines': notifyDeadlines,
    'notifyNews': notifyNews,
  };

  @override
  List<Object?> get props => [
    about,
    telegram,
    showCancelled,
    onlySubgroup,
    notifyLessons,
    notifyDeadlines,
    notifyNews,
  ];
}

class ProfileExtrasCubit extends HydratedCubit<ProfileExtrasState> {
  ProfileExtrasCubit({this.userId = ''}) : super(const ProfileExtrasState());

  final String userId;

  @override
  String get id => userId;

  void setBio({required String about, required String telegram}) {
    emit(state.copyWith(about: about.trim(), telegram: _cleanHandle(telegram)));
  }

  void setShowCancelled({required bool value}) =>
      emit(state.copyWith(showCancelled: value));

  void setOnlySubgroup({required bool value}) =>
      emit(state.copyWith(onlySubgroup: value));

  void setNotifyLessons({required bool value}) =>
      emit(state.copyWith(notifyLessons: value));

  void setNotifyDeadlines({required bool value}) =>
      emit(state.copyWith(notifyDeadlines: value));

  void setNotifyNews({required bool value}) =>
      emit(state.copyWith(notifyNews: value));

  static String _cleanHandle(String value) {
    final clean = value.trim().replaceFirst('@', '');
    return clean.isEmpty ? '' : '@$clean';
  }

  @override
  ProfileExtrasState? fromJson(Map<String, dynamic> json) {
    try {
      return ProfileExtrasState.fromJson(json);
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ProfileExtrasState state) => state.toJson();
}
