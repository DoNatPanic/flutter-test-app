// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ArticleDao? _articleDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Articles` (`title` TEXT NOT NULL, `description` TEXT NOT NULL, `urlToImage` TEXT NOT NULL, `content` TEXT NOT NULL, `url` TEXT NOT NULL, `commentsCount` INTEGER NOT NULL, `comments` TEXT NOT NULL, PRIMARY KEY (`url`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ArticleDao get articleDao {
    return _articleDaoInstance ??= _$ArticleDao(database, changeListener);
  }
}

class _$ArticleDao extends ArticleDao {
  _$ArticleDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _articleEntityInsertionAdapter = InsertionAdapter(
            database,
            'Articles',
            (ArticleEntity item) => <String, Object?>{
                  'title': item.title,
                  'description': item.description,
                  'urlToImage': item.urlToImage,
                  'content': item.content,
                  'url': item.url,
                  'commentsCount': item.commentsCount,
                  'comments': item.comments
                }),
        _articleEntityUpdateAdapter = UpdateAdapter(
            database,
            'Articles',
            ['url'],
            (ArticleEntity item) => <String, Object?>{
                  'title': item.title,
                  'description': item.description,
                  'urlToImage': item.urlToImage,
                  'content': item.content,
                  'url': item.url,
                  'commentsCount': item.commentsCount,
                  'comments': item.comments
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ArticleEntity> _articleEntityInsertionAdapter;

  final UpdateAdapter<ArticleEntity> _articleEntityUpdateAdapter;

  @override
  Future<List<ArticleEntity>> searchArticles(String text) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Articles WHERE title LIKE \'%\' || ?1 || \'%\' OR description LIKE \'%\' || ?1 || \'%\'',
        mapper: (Map<String, Object?> row) => ArticleEntity(title: row['title'] as String, description: row['description'] as String, urlToImage: row['urlToImage'] as String, content: row['content'] as String, url: row['url'] as String, commentsCount: row['commentsCount'] as int, comments: row['comments'] as String),
        arguments: [text]);
  }

  @override
  Future<ArticleEntity?> findArticleByUrl(String url) async {
    return _queryAdapter.query('SELECT * FROM Articles WHERE url = ?1',
        mapper: (Map<String, Object?> row) => ArticleEntity(
            title: row['title'] as String,
            description: row['description'] as String,
            urlToImage: row['urlToImage'] as String,
            content: row['content'] as String,
            url: row['url'] as String,
            commentsCount: row['commentsCount'] as int,
            comments: row['comments'] as String),
        arguments: [url]);
  }

  @override
  Future<void> saveArticle(ArticleEntity article) async {
    await _articleEntityInsertionAdapter.insert(
        article, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertArticle(ArticleEntity article) async {
    await _articleEntityInsertionAdapter.insert(
        article, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateArticle(ArticleEntity article) async {
    await _articleEntityUpdateAdapter.update(article, OnConflictStrategy.abort);
  }
}
