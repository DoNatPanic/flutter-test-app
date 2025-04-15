import 'package:olkonapp/data/converters/article_converter.dart';
import 'package:olkonapp/data/dto/news_dto.dart';
import 'package:olkonapp/domain/models/news.dart';
import 'package:olkonapp/domain/news_repository.dart';
import 'package:olkonapp/services/news_api.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiService newsApiService;
  final ArticleConverter articleConverter;

  NewsRepositoryImpl({
    required this.newsApiService,
    required this.articleConverter,
  });

  @override
  Future<News> getNews(String text) async {
    NewsDto newsDto = await newsApiService.fetchData(text);
    return articleConverter.convertNews(newsDto);
  }
}
