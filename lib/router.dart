import 'package:go_router/go_router.dart';
import 'package:olkonapp/domain/models/article.dart';
import 'package:olkonapp/domain/user_repository.dart';
import 'package:olkonapp/ui/fragments/login_screen.dart';
import 'package:olkonapp/ui/fragments/news_screen.dart';
import 'package:olkonapp/ui/fragments/article_screen.dart';

GoRouter getRouter(UserRepository userRepository) {
  return GoRouter(
    initialLocation: '/${LoginScreen.routeName}',
    routes: [
      GoRoute(
        path: '/${LoginScreen.routeName}',
        name: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/${NewsScreen.routeName}',
        name: NewsScreen.routeName,
        builder: (context, state) => const NewsScreen(),
        routes: [
          GoRoute(
            path: ArticleScreen.routeName,
            name: ArticleScreen.routeName,
            builder: (context, state) {
              final article = state.extra as Article;
              return ArticleScreen(article: article);
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      if (userRepository.getIsLoggedIn()) {
        return '/${NewsScreen.routeName}';
      }
      // no need to redirect at all
      return null;
    },
  );
}
