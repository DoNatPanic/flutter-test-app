import 'package:olkonapp/data/converters/article_converter.dart';
import 'package:olkonapp/data/dto/news_dto.dart';
import 'package:olkonapp/domain/models/news.dart';
import 'package:olkonapp/domain/repositories/news_repository.dart';
import 'package:olkonapp/services/api/news_api_service.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiService newsApiService;
  final ArticleConverter articleConverter;

  NewsRepositoryImpl({
    required this.newsApiService,
    required this.articleConverter,
  });

  @override
  Future<News> getNews(String text, int page) async {
    NewsDto newsDto = await newsApiService.fetchData(text, page);
    return articleConverter.convertNews(newsDto);
  }
}
