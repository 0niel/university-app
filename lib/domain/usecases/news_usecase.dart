import 'package:rtu_mirea_app/data/repositories/news_data_repository.dart';
import 'package:rtu_mirea_app/data/datasources/news_service.dart';

class NewsUsecase {
  static late NewsDataRepository _newsdata;
  static int limit = 10;
  static String tag = 'все';
  static NewsDataRepository NewsDataRepostory() {
    _newsdata = NewsDataRepository(NewsService());
    return _newsdata;
  }
}
