import 'package:olkonapp/domain/models/article.dart';

class News {
  final int totalResults;
  final List<Article> articles;

  News({required this.totalResults, required this.articles});
}
