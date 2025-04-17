import 'package:olkonapp/domain/models/comment.dart';

class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String content;
  final String url;
  int commentsCount;
  List<Comment> comments;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.content,
    required this.url,
    required this.commentsCount,
    required this.comments,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'content': content,
      'url': url,
      'commentsCount': commentsCount,
      'comments': comments,
    };
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      urlToImage: json['urlToImage'],
      content: json['content'],
      url: json['url'],
      commentsCount: json['commentsCount'],
      comments: json['comments'],
    );
  }
}
