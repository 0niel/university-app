import 'dart:convert';

import 'package:rtu_mirea_app/domain/entities/announce.dart';

class AnnounceModel extends Announce {
  const AnnounceModel({
    required name,
    required text,
    required date,
  }) : super(name: name, text: text, date: date);

  factory AnnounceModel.fromRawJson(String str) =>
      AnnounceModel.fromJson(json.decode(str));

  factory AnnounceModel.fromJson(Map<String, dynamic> json) {
    return AnnounceModel(
      name: json["NAME"],
      text: json["PREVIEW_TEXT"],
      date: json["DATE_ACTIVE_FROM"] ?? "",
    );
  }
}
