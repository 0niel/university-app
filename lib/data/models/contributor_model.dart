import 'dart:convert';

import 'package:rtu_mirea_app/domain/entities/contributor.dart';

class ContributorModel extends Contributor {
  const ContributorModel({
    required login,
    required avatarUrl,
    required htmlUrl,
    required contributions,
  }) : super(
          login: login,
          avatarUrl: avatarUrl,
          htmlUrl: htmlUrl,
          contributions: contributions,
        );

  factory ContributorModel.fromRawJson(String str) =>
      ContributorModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContributorModel.fromJson(Map<String, dynamic> json) =>
      ContributorModel(
        login: json["login"],
        avatarUrl: json["avatar_url"],
        htmlUrl: json["html_url"],
        contributions: json["contributions"],
      );

  Map<String, dynamic> toJson() => {
        "login": login,
        "avatar_url": avatarUrl,
        "html_url": htmlUrl,
        "contributions": contributions,
      };
}
