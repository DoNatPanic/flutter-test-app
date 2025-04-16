import 'package:floor/floor.dart';
import 'package:olkonapp/data/database/article_entity.dart';

@dao
abstract class ArticleDao {
  @Query('SELECT * FROM Articles')
  Future<List<ArticleEntity>> findAllArticles();

  @Query('SELECT url FROM Articles')
  Future<List<String>> findAllArticlesUrls();

  @Query('SELECT * FROM Articles WHERE url = :url')
  Stream<ArticleEntity?> findArtucleByUrl(String url);

  @insert
  Future<void> insertArticle(ArticleEntity article);
}
