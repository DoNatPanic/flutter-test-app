class ArticleDto {
  final String? title;
  final String? description;
  final String? urlToImage;
  final String? content;
  final String? url;

  ArticleDto({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.content,
    required this.url,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'content': content,
      'url': url,
    };
  }

  // Factory constructor to create a UserDTO from JSON
  factory ArticleDto.fromJson(Map<String, dynamic> json) {
    return ArticleDto(
      title: json['title'],
      description: json['description'],
      urlToImage: json['urlToImage'],
      content: json['content'],
      url: json['url'],
    );
  }
}
