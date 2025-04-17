import 'package:olkonapp/domain/models/article.dart';

abstract class ArticlesRepository {
  Future<List<Article>> searchArticles(String text);
  Future<void> updateArticle(Article article);
  Future<List<Article>> insertUpdate(List<Article> articles);
  Future<void> saveArticle(Article article);
}
