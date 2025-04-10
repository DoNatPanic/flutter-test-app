import 'package:olkonapp/data/converters/article_converter.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/domain/news_repository.dart';
import 'package:olkonapp/services/news_api.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl({
    required NewsApiService newsApiService,
    required ArticleConverter articleConverter,
  }) : _newsApiService = newsApiService,
       _articleConverter = articleConverter;

  late final NewsApiService _newsApiService;
  late final ArticleConverter _articleConverter;

  @override
  Future<List<Article>> getNewsList(String text) async {
    var news = await _newsApiService.fetchData(text);
    return _articleConverter.convertNews(news);
  }
}
