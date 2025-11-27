// Este arquivo só será compilado quando não for web
// Para web, use database_service_web.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/product.dart';
import 'database_service.dart';

// Implementação para Desktop/Mobile usando SQLite
class DatabaseServiceNative implements DatabaseService {
  static Database? _database;
  static const String _dbName = 'app_turismo.db';
  static const int _dbVersion = 1;

  // Tabelas
  static const String usersTable = 'users';
  static const String productsTable = 'products';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Criar tabela de usuários
    await db.execute('''
      CREATE TABLE $usersTable (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        phone TEXT,
        address TEXT,
        isSeller INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT
      )
    ''');

    // Criar tabela de produtos
    await db.execute('''
      CREATE TABLE $productsTable (
        id TEXT PRIMARY KEY,
        sellerId TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        category TEXT NOT NULL,
        images TEXT,
        stock INTEGER NOT NULL DEFAULT 0,
        isAvailable INTEGER NOT NULL DEFAULT 1,
        location TEXT,
        latitude REAL,
        longitude REAL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT,
        FOREIGN KEY (sellerId) REFERENCES $usersTable (id)
      )
    ''');

    // Índices
    await db.execute('CREATE INDEX idx_seller_id ON $productsTable(sellerId)');
    await db.execute('CREATE INDEX idx_product_category ON $productsTable(category)');
    await db.execute('CREATE INDEX idx_user_email ON $usersTable(email)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementar migrações se necessário
  }

  @override
  Future<String> insertUser(User user) async {
    final db = await database;
    await db.insert(
      usersTable,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return user.id;
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final results = await db.query(
      usersTable,
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return User.fromJson(results.first);
  }

  @override
  Future<User?> getUserById(String id) async {
    final db = await database;
    final results = await db.query(
      usersTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return User.fromJson(results.first);
  }

  @override
  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      usersTable,
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  @override
  Future<String> insertProduct(Product product) async {
    final db = await database;
    await db.insert(
      productsTable,
      {
        ...product.toJson(),
        'images': product.images.join(','), // SQLite não suporta arrays
        'isAvailable': product.isAvailable ? 1 : 0,
      }..removeWhere((key, value) => key == 'isSeller'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return product.id;
  }

  @override
  Future<List<Product>> getAllProducts({String? category, String? sellerId}) async {
    final db = await database;
    String where = 'isAvailable = 1';
    List<dynamic> whereArgs = [];

    if (category != null) {
      where += ' AND category = ?';
      whereArgs.add(category);
    }

    if (sellerId != null) {
      where += ' AND sellerId = ?';
      whereArgs.add(sellerId);
    }

    final results = await db.query(
      productsTable,
      where: whereArgs.isEmpty ? where : where,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'createdAt DESC',
    );

    return results.map((json) {
      final imagesStr = json['images'] as String? ?? '';
      return Product.fromJson({
        ...json,
        'images': imagesStr.isEmpty ? [] : imagesStr.split(','),
        'isAvailable': (json['isAvailable'] as int) == 1,
      });
    }).toList();
  }

  @override
  Future<Product?> getProductById(String id) async {
    final db = await database;
    final results = await db.query(
      productsTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) return null;

    final json = results.first;
    final imagesStr = json['images'] as String? ?? '';
    return Product.fromJson({
      ...json,
      'images': imagesStr.isEmpty ? [] : imagesStr.split(','),
      'isAvailable': (json['isAvailable'] as int) == 1,
    });
  }

  @override
  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      productsTable,
      {
        ...product.toJson(),
        'images': product.images.join(','),
        'isAvailable': product.isAvailable ? 1 : 0,
      }..removeWhere((key, value) => key == 'isSeller'),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  @override
  Future<void> deleteProduct(String id) async {
    final db = await database;
    await db.delete(
      productsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
