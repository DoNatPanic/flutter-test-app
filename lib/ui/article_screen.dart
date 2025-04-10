import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/domain/models/comment.dart';
import 'package:olkonapp/domain/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleScreen extends StatefulWidget {
  final Article article;
  final bool scrollToComments;

  const ArticleScreen({
    super.key,
    required this.article,
    this.scrollToComments = false,
  });

  static const routeName = 'article';

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late UserRepository _userRepository;
  final GlobalKey _targetKey = GlobalKey();

  final List<Comment> _comments = [
    Comment(
      name: 'John',
      text: 'I learned a lot from the article, thanks!',
      time: '10-04-2025 08:21',
    ),
    Comment(
      name: 'John',
      text: 'I learned a lot from the article, thanks!',
      time: '10-04-2025 08:21',
    ),
    Comment(
      name: 'John',
      text: 'I learned a lot from the article, thanks!',
      time: '10-04-2025 08:21',
    ),
    Comment(
      name: 'John',
      text: 'I learned a lot from the article, thanks!',
      time: '10-04-2025 08:21',
    ),
    Comment(
      name: 'John',
      text: 'I learned a lot from the article, thanks!',
      time: '10-04-2025 08:21',
    ),
    Comment(
      name: 'John',
      text: 'I learned a lot from the article, thanks!',
      time: '10-04-2025 08:21',
    ),
  ];

  void scrollToTarget() {
    final context = _targetKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    _userRepository = Provider.of<UserRepository>(context, listen: false);

    // дожидаемся рендеринга экрана и затем запускаем прокрутку
    if (widget.scrollToComments) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToTarget();
      });
    }

    super.initState();
  }

  final TextEditingController _commentController = TextEditingController();

  void addComment(String commentText) {
    setState(() {
      _comments.add(
        Comment(
          name: _userRepository.getUserName()!,
          text: commentText,
          time: getTime(),
        ),
      );
    });
    _commentController.clear(); // Очистить поле ввода после добавления
  }

  String getTime() {
    var formatter = DateFormat('dd-MM-yyyy hh:mm');
    return formatter.format(DateTime.now());
  }

  String trimText(String input) {
    return input.length <= 200 ? input : input.substring(0, 200);
  }

  void openUrl(String url) {
    try {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text('Cant open the website'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.article.title, // Заголовок
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 10),
              Image.network(
                widget.article.urlToImage, // URL изображения
                loadingBuilder: (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                      ),
                    );
                  }
                },
                errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                ) {
                  return Center(
                    child: Icon(Icons.error),
                  ); // Показывает иконку ошибки, если изображение не загрузилось
                },
              ),
              const SizedBox(height: 10),
              Text(
                trimText(widget.article.content), // Основной текст статьи
                style: TextStyle(fontSize: 16),
              ),
              TextButton(
                onPressed: () => openUrl(widget.article.url),
                child: Text(
                  "Read more on website",
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Comments", // Основной текст статьи
                key: _targetKey,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              // Список комментариев
              ..._comments.map(
                (comment) => ListTile(
                  leading: CircleAvatar(child: Text(comment.name[0])),
                  title: Text(comment.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.text),
                      SizedBox(height: 6),
                      Text(comment.time),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Поле ввода нового комментария
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        labelText: 'Add a comment...',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        addComment(_commentController.text);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
