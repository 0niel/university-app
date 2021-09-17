import 'package:equatable/equatable.dart';

/// Class which provides additional info like specific lesson notes or tags
class LessonAppInfo extends Equatable {
  LessonAppInfo({
    this.id,
    this.note = "",
    required this.lessonCode,
  });

  String note;
  final int? id;
  final String lessonCode;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'lessonCode': lessonCode
    };
  }

  @override
  List<Object?> get props => [id, note, lessonCode];
}