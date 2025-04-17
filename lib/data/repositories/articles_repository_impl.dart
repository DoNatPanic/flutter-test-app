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
  Future<List<Article>> searchArticles(String text) async {
    List<ArticleEntity> articleEntities = await databaseService.articleDao
        .searchArticles(text);
    return _convertToArticleList(articleEntities);
  }

  @override
  Future<void> updateArticle(Article article) async {
    ArticleEntity entity = _convertToEntity(article);
    await databaseService.articleDao.updateArticle(entity);
  }

  @override
  Future<List<Article>> insertUpdate(List<Article> articles) async {
    List<ArticleEntity> entitiesList = _convertToEntitiesList(articles);
    List<ArticleEntity> list = await databaseService.articleDao.insertUpdate(
      entitiesList,
    );
    return _convertToArticleList(list);
  }

  @override
  Future<void> saveArticle(Article article) async {
    ArticleEntity entity = _convertToEntity(article);
    await databaseService.articleDao.saveArticle(entity);
  }

  Article _convertToArticle(ArticleEntity entity) {
    return articleConverter.convertFromEntityToArticle(entity);
  }

  ArticleEntity _convertToEntity(Article article) {
    return articleConverter.convertFromArticleToEntity(article);
  }

  List<Article> _convertToArticleList(List<ArticleEntity> entities) {
    return entities
        .map((ArticleEntity entity) => _convertToArticle(entity))
        .toList();
  }

  List<ArticleEntity> _convertToEntitiesList(List<Article> articles) {
    return articles
        .map((Article article) => _convertToEntity(article))
        .toList();
  }
}
