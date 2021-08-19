import 'package:rtu_mirea_app/domain/entities/news.dart';
import 'package:http/http.dart' as http;
import 'package:rtu_mirea_app/domain/entities/tag.dart';
import 'dart:convert';

class NewsService {
  static const _URL = "http://192.168.1.87:8000/news";
  static const _tagURI = "http://192.168.1.87:8000/tags";

  Future<List<NewsModel>> getNews(offset, limit, tag) async {
    var response = await http
        .get(Uri.parse(_URL + '?tag=${tag}&limit=${limit}&offset=${offset}'));
    var body = json.decode(utf8.decode(response.bodyBytes));
    return body["news"]
        .map<NewsModel>((news) => NewsModel.from_json(news))
        .toList();
  }

  Future<List<Tag>> getTags() async {
    var response = await http.get(Uri.parse(_tagURI));
    var body = json.decode(utf8.decode(response.bodyBytes));
    return body['tags'].map<Tag>((tag) => Tag.from_json(tag)).toList();
  }
}
