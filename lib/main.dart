import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:olkonapp/data/converters/article_converter.dart';
import 'package:olkonapp/data/repositories/articles_repository_impl.dart';
import 'package:olkonapp/data/repositories/news_repository_impl.dart';
import 'package:olkonapp/data/repositories/user_repository_impl.dart';
import 'package:olkonapp/domain/repositories/articles_repository.dart';
import 'package:olkonapp/domain/repositories/news_repository.dart';
import 'package:olkonapp/domain/repositories/user_repository.dart';
import 'package:olkonapp/router.dart';
import 'package:olkonapp/services/api/database_service.dart';
import 'package:olkonapp/services/api/news_api_service.dart';
import 'package:olkonapp/services/impls/database_service_impl.dart';
import 'package:olkonapp/services/impls/news_api_service_impl.dart';
import 'package:olkonapp/services/api/shared_preferences_service.dart';
import 'package:olkonapp/services/impls/shared_preferences_service_impl.dart';
import 'package:olkonapp/ui/fragments/news_screen.dart';
import 'package:olkonapp/ui/view_models/login_view_model.dart';
import 'package:olkonapp/ui/view_models/news_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  // Асинхронно создаём и инициализируем DatabaseService
  final DatabaseService dbService = DatabaseServiceImpl();
  await dbService.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<DatabaseService>.value(value: dbService),
        Provider<SharedPreferencesService>(
          create: (BuildContext context) => SharedPreferencesServiceImpl(),
        ),
        Provider<NewsApiService>(
          create: (BuildContext context) => NewsApiServiceImpl(),
        ),
        Provider<ArticleConverter>(
          create: (BuildContext context) => ArticleConverter(),
        ),
        Provider<UserRepository>(
          create:
              (BuildContext context) =>
                  UserRepositoryImpl(sharedPreferencesService: context.read())
                      as UserRepository,
        ),
        Provider<NewsRepository>(
          create:
              (BuildContext context) =>
                  NewsRepositoryImpl(
                        newsApiService: context.read(),
                        articleConverter: context.read(),
                      )
                      as NewsRepository,
        ),
        Provider<ArticlesRepository>(
          create:
              (BuildContext context) =>
                  ArticlesRepositoryImpl(
                        databaseService: context.read(),
                        articleConverter: context.read(),
                      )
                      as ArticlesRepository,
        ),
        ChangeNotifierProvider<NewsViewModel>(
          create:
              (BuildContext context) => NewsViewModel(
                newsRepository: context.read<NewsRepository>(),
                userRepository: context.read<UserRepository>(),
                articlesRepository: context.read<ArticlesRepository>(),
              ),
          child: const NewsScreen(),
        ),
        // ChangeNotifierProvider<ArticleViewModel>(
        //   create:
        //       (BuildContext context) => ArticleViewModel(
        //         userRepository: context.read<UserRepository>(),
        //         articlesRepository: context.read<ArticlesRepository>(),
        //       ),
        // ),
        ChangeNotifierProvider<LoginViewModel>(
          create:
              (BuildContext context) => LoginViewModel(
                userRepository: context.read<UserRepository>(),
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(
      context,
      listen: false,
    );

    return FutureBuilder<void>(
      future: userRepository.loadUserData(),
      builder: ((BuildContext context, AsyncSnapshot<void> snapshot) {
        GoRouter router = getRouter(userRepository); // Получаем роутер

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        );
      }),
    );
  }
}
