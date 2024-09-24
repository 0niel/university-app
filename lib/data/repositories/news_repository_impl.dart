import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/data/datasources/news_remote.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteData remoteDataSource;

  NewsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<NewsItem>>> getNews(int page, int pageSize, bool isImportant, [String? tag]) async {
    try {
      final newsList = await remoteDataSource.getNews(page, pageSize, isImportant, tag);
      return Right(newsList);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getTags() async {
    try {
      final tagsList = await remoteDataSource.getTags();
      return Right(tagsList);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }
}
