import 'dart:convert';

import 'package:rtu_mirea_app/domain/entities/score.dart';

class ScoreModel extends Score {
  const ScoreModel({
    required subjectName,
    required result,
    required type,
    required comission,
    required date,
    required year,
    required courseWork,
    required exam,
    required credit,
  }) : super(
          subjectName: subjectName,
          result: result,
          type: type,
          comission: comission,
          courseWork: courseWork,
          exam: exam,
          credit: credit,
          date: date,
          year: year,
        );

  factory ScoreModel.fromRawJson(String str) =>
      ScoreModel.fromJson(json.decode(str));

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      subjectName: json["SUBJECT_NAME"],
      result: json["RESULT"],
      type: json["LOAD_TYPE"],
      comission: json["UF_COMISSION"],
      date: json["DATE_FORMATED"],
      year: json["YEAR_NAME"],
      courseWork: json["UF_COURSEWORK"],
      exam: json["UF_EXAM"],
      credit: json["UF_CREDIT"],
    );
  }
}
