import 'package:floor/floor.dart';

@Entity(tableName: 'Articles')
class ArticleEntity {
  final String title;
  final String description;
  final String urlToImage;
  final String content;
  @primaryKey
  final String url;
  final int commentsCount;
  final String comments;

  ArticleEntity({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.content,
    required this.url,
    required this.commentsCount,
    required this.comments,
  });
}
