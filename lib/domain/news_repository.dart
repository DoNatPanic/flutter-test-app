import 'package:olkonapp/domain/models/article.dart';

abstract class NewsRepository {
  Future<List<Article>> getNewsList(String text);
}
