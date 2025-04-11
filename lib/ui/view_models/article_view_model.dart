import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:olkonapp/domain/models/comment.dart';
import 'package:olkonapp/domain/user_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleViewModel extends ChangeNotifier {
  final UserRepository userRepository;

  final List<Comment> comments = [];
  final TextEditingController commentController = TextEditingController();
  final GlobalKey commentSectionKey = GlobalKey();

  ArticleViewModel({required this.userRepository}) {
    _loadInitialComments();
  }

  void _loadInitialComments() {
    // Пример начальных комментариев
    comments.addAll(
      List.generate(
        6,
        (index) => Comment(
          name: 'John',
          text: 'I learned a lot from the article, thanks!',
          time: getTime(),
        ),
      ),
    );
  }

  void addComment(String commentText) {
    final userName = userRepository.getUserName();
    if (userName == null || commentText.isEmpty) return;

    comments.add(Comment(name: userName, text: commentText, time: getTime()));
    commentController.clear();
    notifyListeners();
  }

  String getTime() {
    return DateFormat('dd-MM-yyyy hh:mm').format(DateTime.now());
  }

  String trimText(String input) {
    return input.length <= 200 ? input : input.substring(0, 200);
  }

  void openUrl(BuildContext context, String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cant open the website')));
    }
  }

  void scrollToComments() {
    final context = commentSectionKey.currentContext;
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
}
