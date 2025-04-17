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
  final Article article;
  final TextEditingController commentController = TextEditingController();

  ArticleViewModel({
    required this.article,
    required this.userRepository,
    required this.articlesRepository,
  });

  void addComment(String commentText) {
    String? userName = userRepository.getUserName;
    if (userName == null || commentText.isEmpty) {
      return;
    }
    Comment comment = Comment(
      name: userName,
      text: commentText,
      time: _getTime(),
    );

    article.comments.add(comment);
    article.commentsCount++;
    commentController.clear();
    articlesRepository.updateArticle(article);
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

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  String _getTime() {
    return DateFormat('dd-MM-yyyy hh:mm').format(DateTime.now());
  }
}
