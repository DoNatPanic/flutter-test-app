import 'package:olkonapp/data/dto/article_dto.dart';

class NewsDto {
  final int? totalResults;
  final List<ArticleDto>? articles;

  NewsDto({required this.totalResults, required this.articles});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'totalResults': totalResults,
      'articles': articles,
    };
  }

  factory NewsDto.fromJson(Map<String, dynamic> json) {
    return NewsDto(
      totalResults: json['totalResults'],
      articles:
          (json['articles'] as List<dynamic>)
              .map((dynamic i) => ArticleDto.fromJson(i))
              .toList(),
    );
  }
}
