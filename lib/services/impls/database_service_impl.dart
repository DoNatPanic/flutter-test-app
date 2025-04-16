import 'package:olkonapp/data/database/app_database.dart';
import 'package:olkonapp/data/database/article_dao.dart';
import 'package:olkonapp/services/api/database_service.dart';

class DatabaseServiceImpl implements DatabaseService {
  late AppDatabase _database;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _initialized = true;
  }

  AppDatabase get database {
    if (!_initialized) {
      throw Exception('DatabaseService not initialized. Call init() first.');
    }
    return _database;
  }

  ArticleDao get articleDao => _database.articleDao;
}
