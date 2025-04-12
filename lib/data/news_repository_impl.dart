import 'package:olkonapp/data/converters/article_converter.dart';
import 'package:olkonapp/data/dto/article_dto.dart';
import 'package:olkonapp/domain/models/article.dart';
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
  Future<List<Article>> getNewsList(String text) async {
    List<ArticleDto> news = await newsApiService.fetchData(text);
    return articleConverter.convertNews(news);
  }
}
