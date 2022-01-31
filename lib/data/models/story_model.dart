import 'package:rtu_mirea_app/data/models/strapi_media_model.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';

class StoryModel extends Story {
  const StoryModel({
    required title,
    required pages,
    required stopShowDate,
    required preview,
    required author,
    required publishedAt,
  }) : super(
            title: title,
            pages: pages,
            stopShowDate: stopShowDate,
            preview: preview,
            author: author,
            publishedAt: publishedAt);

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
        title: json["title"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        stopShowDate: DateTime.parse(json["stopShowDate"]),
        author: AuthorModel.fromJson(json["author"]["data"]["attributes"]),
        pages: List<StoryPageModel>.from(
            json["pages"].map((x) => StoryPageModel.fromJson(x))),
        preview:
            StrapiMediaModel.fromJson(json["preview"]["data"]["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "publishedAt": publishedAt.toIso8601String(),
        "stopShowDate":
            "${stopShowDate.year.toString().padLeft(4, '0')}-${stopShowDate.month.toString().padLeft(2, '0')}-${stopShowDate.day.toString().padLeft(2, '0')}",
        "author": (author as AuthorModel).toJson(),
        "pages": List<dynamic>.from(
            pages.map((x) => (x as StoryPageModel).toJson())),
        "preview": (preview as StrapiMediaModel).toJson(),
      };
}

class StoryPageModel extends StoryPage {
  const StoryPageModel({
    required title,
    required text,
    required media,
    required actions,
  }) : super(title: title, text: text, media: media, actions: actions);

  factory StoryPageModel.fromJson(Map<String, dynamic> json) => StoryPageModel(
        title: json["title"],
        text: json["text"],
        actions: List<StoryPageActionModel>.from(
            json["actions"].map((x) => StoryPageActionModel.fromJson(x))),
        media: StrapiMediaModel.fromJson(json["media"]["data"]["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "text": text,
        "actions": List<StoryPageActionModel>.from(actions.map((x) => x)),
        "media": media,
      };
}

class StoryPageActionModel extends StoryPageAction {
  const StoryPageActionModel({
    required title,
    required url,
  }) : super(title: title, url: url);

  factory StoryPageActionModel.fromJson(Map<String, dynamic> json) =>
      StoryPageActionModel(
        title: json["title"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
      };
}

class AuthorModel extends Author {
  const AuthorModel({
    required name,
    required url,
    required logo,
  }) : super(name: name, url: url, logo: logo);

  factory AuthorModel.fromJson(Map<String, dynamic> json) => AuthorModel(
        name: json["name"],
        url: json["url"],
        logo: StrapiMediaModel.fromJson(json["logo"]["data"]["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
        "logo": logo,
      };
}
