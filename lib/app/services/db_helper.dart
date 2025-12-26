import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/movie_model.dart';

class DbHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = join(await getDatabasesPath(), 'movie_app.db');

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE search_cache (
            imdb_id TEXT PRIMARY KEY,
            title TEXT,
            year TEXT,
            type TEXT,
            poster TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE movie_details (
            imdb_id TEXT PRIMARY KEY,
            data TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveSearch(List<Search> movies) async {
    final database = await this.database;

    await database.delete('search_cache');

    final batch = database.batch();
    for (final movie in movies) {
      batch.insert('search_cache', {
        'imdb_id': movie.imdbId,
        'title': movie.title,
        'year': movie.year,
        'type': movie.type,
        'poster': movie.poster,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Search>> getCachedSearch() async {
    final database = await this.database;

    final result = await database.query('search_cache');

    return result.map((row) {
      return Search(
        imdbId: row['imdb_id'] as String,
        title: row['title'] as String,
        year: row['year'] as String,
        type: row['type'] as String,
        poster: row['poster'] as String,
      );
    }).toList();
  }

  Future<void> saveMovieDetails(String imdbId, String jsonContent) async {
    final database = await this.database;

    await database.insert('movie_details', {
      'imdb_id': imdbId,
      'data': jsonContent,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getCachedMovieDetails(String imdbId) async {
    final database = await this.database;

    final result = await database.query(
      'movie_details',
      where: 'imdb_id = ?',
      whereArgs: [imdbId],
      limit: 1,
    );

    return result.isNotEmpty ? result.first['data'] as String : null;
  }
}
