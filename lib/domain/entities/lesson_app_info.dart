import 'package:equatable/equatable.dart';

/// Class which provides additional info like specific lesson notes or tags
class LessonAppInfo extends Equatable {
  const LessonAppInfo({
    required this.id,
    required this.lessonCode,
    required this.note,
  });

  final int id;
  final String note;
  final String lessonCode;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'lessonCode': lessonCode
    };
  }

  @override
  List<Object?> get props => throw UnimplementedError();
}