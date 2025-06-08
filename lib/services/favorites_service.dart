import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

class FavoritesService {
  static Database? _database;
  static const String _tableName = 'favorites';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'favorites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            price REAL,
            imageUrl TEXT,
            stockQuantity INTEGER,
            categoryId INTEGER,
            createdAt TEXT,
            updatedAt TEXT
          )
        ''');
      },
    );
  }

  Future<void> addToFavorites(Product product) async {
    final db = await database;
    await db.insert(
      _tableName,
      {
        'id': product.id,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'stockQuantity': product.stockQuantity,
        'categoryId': product.categoryId,
        'createdAt': product.createdAt.toIso8601String(),
        'updatedAt': product.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFromFavorites(int productId) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  Future<List<Product>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        price: maps[i]['price'],
        imageUrl: maps[i]['imageUrl'],
        stockQuantity: maps[i]['stockQuantity'],
        categoryId: maps[i]['categoryId'],
        createdAt: DateTime.parse(maps[i]['createdAt']),
        updatedAt: DateTime.parse(maps[i]['updatedAt']),
      );
    });
  }

  Future<bool> isFavorite(int productId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [productId],
    );
    return result.isNotEmpty;
  }
}
