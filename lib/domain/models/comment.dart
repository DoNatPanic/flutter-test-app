class Comment {
  final String name;
  final String text;
  final String time;

  Comment({required this.name, required this.text, required this.time});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'text': text, 'time': time};
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(name: json['name'], text: json['text'], time: json['time']);
  }
}
