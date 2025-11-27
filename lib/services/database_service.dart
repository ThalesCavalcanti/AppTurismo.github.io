import '../models/user.dart';
import '../models/product.dart';

// Interface abstrata para o serviço de banco de dados
abstract class DatabaseService {
  Future<String> insertUser(User user);
  Future<User?> getUserByEmail(String email);
  Future<User?> getUserById(String id);
  Future<void> updateUser(User user);
  Future<String> insertProduct(Product product);
  Future<List<Product>> getAllProducts({String? category, String? sellerId});
  Future<Product?> getProductById(String id);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
  Future<void> close();
}
