import 'package:olkonapp/domain/models/comment.dart';

class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String content;
  final String url;
  final int commentsCount;
  final List<Comment> comments;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.content,
    required this.url,
    this.commentsCount = 0,
    this.comments = const [],
  });
}
