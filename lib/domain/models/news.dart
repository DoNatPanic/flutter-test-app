import 'package:olkonapp/domain/models/article.dart';

class News {
  final int totalResults;
  List<Article> articles;

  News({required this.totalResults, required this.articles});
}
