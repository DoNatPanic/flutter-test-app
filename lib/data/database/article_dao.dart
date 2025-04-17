import 'package:floor/floor.dart';
import 'package:olkonapp/data/database/article_entity.dart';

@dao
abstract class ArticleDao {
  // Метод для поиска статей по title или description, содержащим text
  @Query(
    "SELECT * FROM Articles WHERE title LIKE '%' || :text || '%' OR description LIKE '%' || :text || '%'",
  )
  Future<List<ArticleEntity>> searchArticles(String text);

  @update
  Future<void> updateArticle(ArticleEntity article);

  @insert
  Future<void> saveArticle(ArticleEntity article);

  // Метод для проверки каждого объекта и вставки, если его нет в базе
  Future<List<ArticleEntity>> insertUpdate(List<ArticleEntity> articles) async {
    for (ArticleEntity article in articles) {
      // Проверяем, есть ли статья в базе данных
      ArticleEntity? existingArticle = await findArticleByUrl(article.url);
      if (existingArticle == null) {
        // Если статьи нет в базе, вставляем её
        await insertArticle(article);
      } else {
        article.comments = existingArticle.comments;
        article.commentsCount = existingArticle.commentsCount;
      }
    }
    return articles;
  }

  @Query('SELECT * FROM Articles WHERE url = :url')
  Future<ArticleEntity?> findArticleByUrl(String url);

  @insert
  Future<void> insertArticle(ArticleEntity article);
}
