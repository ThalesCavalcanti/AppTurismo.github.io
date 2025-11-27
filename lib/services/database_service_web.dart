import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/product.dart';
import 'database_service.dart';

// Implementação para Web usando SharedPreferences
class DatabaseServiceWeb implements DatabaseService {
  static const String _usersKey = 'db_users';
  static const String _productsKey = 'db_products';

  @override
  Future<String> insertUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    
    // Remover usuário existente com mesmo email
    usersJson.removeWhere((json) {
      try {
        final existing = User.fromJson(jsonDecode(json));
        return existing.email == user.email;
      } catch (e) {
        return false;
      }
    });
    
    usersJson.add(jsonEncode(user.toJson()));
    await prefs.setStringList(_usersKey, usersJson);
    return user.id;
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final users = await _getAllUsers();
    try {
      return users.firstWhere((u) => u.email == email);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> getUserById(String id) async {
    final users = await _getAllUsers();
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateUser(User user) async {
    await insertUser(user); // Replace
  }

  @override
  Future<String> insertProduct(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getStringList(_productsKey) ?? [];
    
    // Remover produto existente com mesmo ID
    productsJson.removeWhere((json) {
      try {
        final existing = Product.fromJson(jsonDecode(json));
        return existing.id == product.id;
      } catch (e) {
        return false;
      }
    });
    
    productsJson.add(jsonEncode(product.toJson()));
    await prefs.setStringList(_productsKey, productsJson);
    return product.id;
  }

  @override
  Future<List<Product>> getAllProducts({String? category, String? sellerId}) async {
    final products = await _getAllProducts();
    
    return products.where((product) {
      if (!product.isAvailable) return false;
      if (category != null && product.category != category) return false;
      if (sellerId != null && product.sellerId != sellerId) return false;
      return true;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<Product?> getProductById(String id) async {
    final products = await _getAllProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    await insertProduct(product); // Replace
  }

  @override
  Future<void> deleteProduct(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getStringList(_productsKey) ?? [];
    
    productsJson.removeWhere((json) {
      try {
        final product = Product.fromJson(jsonDecode(json));
        return product.id == id;
      } catch (e) {
        return false;
      }
    });
    
    await prefs.setStringList(_productsKey, productsJson);
  }

  @override
  Future<void> close() async {
    // SharedPreferences não precisa de close
  }

  Future<List<User>> _getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    return usersJson
        .map((json) => User.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<List<Product>> _getAllProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getStringList(_productsKey) ?? [];
    return productsJson
        .map((json) => Product.fromJson(jsonDecode(json)))
        .toList();
  }
}

