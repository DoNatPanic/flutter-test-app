import 'package:olkonapp/domain/models/article.dart';

abstract class ArticlesRepository {
  Future<List<Article>> searchArticles(String text);
  Future<Article> getArticleByUrl(String url);
  Future<void> save(Article article);
}
