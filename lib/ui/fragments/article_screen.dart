import 'package:flutter/material.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/domain/models/comment.dart';
import 'package:olkonapp/domain/repositories/articles_repository.dart';
import 'package:olkonapp/domain/repositories/user_repository.dart';
import 'package:olkonapp/ui/view_models/article_view_model.dart';
import 'package:provider/provider.dart';

class ArticleScreen extends StatefulWidget {
  static const String routeName = 'article';

  final Article article;
  final bool scrollToComments;

  const ArticleScreen({
    super.key,
    required this.article,
    this.scrollToComments = false,
  });

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late ArticleViewModel _viewModel;
  final GlobalKey _commentSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _viewModel = ArticleViewModel(
      article: widget.article,
      userRepository: context.read<UserRepository>(),
      articlesRepository: context.read<ArticlesRepository>(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollToComments) {
        _scrollToComments();
      }
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArticleViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(),
        body: Consumer<ArticleViewModel>(
          builder: (BuildContext context, ArticleViewModel viewModel, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.article.title,
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 10),
                  if (widget.article.urlToImage.isNotEmpty)
                    Image.network(
                      widget.article.urlToImage,
                      loadingBuilder: (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? progress,
                      ) {
                        if (progress == null) {
                          return child;
                        }
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
                          (_, __, ___) =>
                              const Center(child: Icon(Icons.error)),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    viewModel.trimText(widget.article.content),
                    style: const TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed:
                        () => viewModel.openUrl(context, widget.article.url),
                    child: const Text(
                      "Read more on website",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Comments",
                    key: _commentSectionKey,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),

                  ...viewModel.article.comments.map(
                    (Comment comment) => ListTile(
                      leading: CircleAvatar(child: Text(comment.name[0])),
                      title: Text(comment.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(comment.text),
                          const SizedBox(height: 6),
                          Text(comment.time),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCommentInput(viewModel),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCommentInput(ArticleViewModel viewModel) {
    return Row(
      children: <Widget>[
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
              viewModel.addComment(viewModel.commentController.text);
            }
          },
        ),
      ],
    );
  }

  void _scrollToComments() {
    final BuildContext? context = _commentSectionKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context);
    }
  }
}
