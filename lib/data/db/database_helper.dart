import 'package:sqflite/sqflite.dart';
import 'package:restaurant_app/data/model/restaurant.dart' as rs;
import 'package:restaurant_app/data/model/detail_restaurant.dart' as rd;

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblFavorite = 'favorites';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurantapp.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblFavorite (
             id TEXT PRIMARY KEY,
             name TEXT,
             description TEXT,
             pictureId TEXT,
             city TEXT,
             rating REAL
           )     
        ''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> insertFavorite(rd.Restaurant restaurantDetail) async {
    final db = await database;
    final restaurant = _convertToRestaurant(restaurantDetail);
    await db!.insert(_tblFavorite, restaurant.toJson());
  }

  Future<List<rs.Restaurant>> getFavorites() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblFavorite);

    return results.map((res) => rs.Restaurant.fromJson(res)).toList();
  }

  Future<Map> getFavoriteByID(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;

    await db!.delete(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  rs.Restaurant _convertToRestaurant(rd.Restaurant restaurantDetail) {
    return rs.Restaurant(
      id: restaurantDetail.id,
      name: restaurantDetail.name,
      description: restaurantDetail.description,
      pictureId: restaurantDetail.pictureId,
      city: restaurantDetail.city,
      rating: restaurantDetail.rating,
    );
  }
}
