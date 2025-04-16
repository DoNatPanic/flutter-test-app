import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:olkonapp/domain/repositories/articles_repository.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/domain/models/comment.dart';
import 'package:olkonapp/domain/repositories/user_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  final ArticlesRepository articlesRepository;
  final List<Comment> comments = <Comment>[];
  final TextEditingController commentController = TextEditingController();
  final GlobalKey commentSectionKey = GlobalKey();

  ArticleViewModel({
    required this.userRepository,
    required this.articlesRepository,
  }) {
    _loadInitialComments();
    var article = Article(
      title: "title",
      description: "description",
      urlToImage: "urlToImage",
      content: "content",
      url: "url",
      comments: <Comment>[],
      commentsCount: 0,
    );
    articlesRepository.save(article);
  }

  void addComment(String commentText) {
    String? userName = userRepository.getUserName;
    if (userName == null || commentText.isEmpty) {
      return;
    }
    comments.add(Comment(name: userName, text: commentText, time: _getTime()));
    commentController.clear();
    notifyListeners();
  }

  String trimText(String input) {
    return input.length <= 200 ? input : input.substring(0, 200);
  }

  void openUrl(BuildContext context, String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cant open the website')));
      }
    }
  }

  void scrollToComments() {
    BuildContext? context = commentSectionKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void _loadInitialComments() {
    // Пример начальных комментариев
    comments.addAll(
      List<Comment>.generate(
        6,
        (int index) => Comment(
          name: 'John',
          text: 'I learned a lot from the article, thanks!',
          time: _getTime(),
        ),
      ),
    );
  }

  String _getTime() {
    return DateFormat('dd-MM-yyyy hh:mm').format(DateTime.now());
  }
}
