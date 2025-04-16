import 'package:olkonapp/data/converters/article_converter.dart';
import 'package:olkonapp/data/database/article_entity.dart';
import 'package:olkonapp/domain/repositories/articles_repository.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/services/api/database_service.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  final DatabaseService databaseService;
  final ArticleConverter articleConverter;

  ArticlesRepositoryImpl({
    required this.databaseService,
    required this.articleConverter,
  });

  @override
  Future<Article> getArticleByUrl(String url) {
    // TODO: implement getArticleByUrl
    throw UnimplementedError();
  }

  @override
  Future<void> save(Article article) async {
    databaseService.articleDao.insertArticle(convertToDB(article));
    // TODO: implement save
    // throw UnimplementedError();
  }

  @override
  Future<List<Article>> searchArticles(String text) {
    // TODO: implement searchArticles
    throw UnimplementedError();
  }

  ArticleEntity convertToDB(Article article) {
    return articleConverter.convertFromArticleToDB(article);
  }
}
