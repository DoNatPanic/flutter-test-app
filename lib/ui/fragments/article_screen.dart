import 'package:flutter/material.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/ui/view_models/article_view_model.dart';
import 'package:provider/provider.dart';

class ArticleScreen extends StatelessWidget {
  final bool scrollToComments;
  final Article article;

  const ArticleScreen({
    super.key,
    required this.article,
    this.scrollToComments = false,
  });

  static const routeName = 'article';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<ArticleViewModel>(
        builder: (context, viewModel, _) {
          // Прокрутка к комментариям после рендера
          if (scrollToComments) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              viewModel.scrollToComments();
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.title, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 10),
                Image.network(
                  article.urlToImage,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    (progress.expectedTotalBytes ?? 1)
                                : null,
                      ),
                    );
                  },
                  errorBuilder:
                      (_, __, ___) => const Center(child: Icon(Icons.error)),
                ),
                const SizedBox(height: 10),
                Text(
                  viewModel.trimText(article.content),
                  style: const TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () => viewModel.openUrl(context, article.url),
                  child: const Text(
                    "Read more on website",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "Comments",
                  key: viewModel.commentSectionKey,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                ...viewModel.comments.map(
                  (comment) => ListTile(
                    leading: CircleAvatar(child: Text(comment.name[0])),
                    title: Text(comment.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment.text),
                        const SizedBox(height: 6),
                        Text(comment.time),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: viewModel.commentController,
                        decoration: const InputDecoration(
                          labelText: 'Add a comment...',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (viewModel.commentController.text.isNotEmpty) {
                          viewModel.addComment(
                            viewModel.commentController.text,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
