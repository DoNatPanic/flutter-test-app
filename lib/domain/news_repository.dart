import 'package:olkonapp/domain/models/news.dart';

abstract class NewsRepository {
  Future<News> getNews(String text, int page);
}
