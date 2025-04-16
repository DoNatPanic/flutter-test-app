import 'package:olkonapp/data/database/app_database.dart';
import 'package:olkonapp/data/database/article_dao.dart';

abstract class DatabaseService {
  Future<void> init(); // Метод для инициализации базы данных
  AppDatabase get database;
  ArticleDao get articleDao;
}
