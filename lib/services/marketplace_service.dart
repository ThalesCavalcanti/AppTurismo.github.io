import '../models/product.dart';
import 'database_service.dart';

class MarketplaceService {
  final DatabaseService _dbService;

  MarketplaceService(this._dbService);

  // Criar produto
  Future<Product> createProduct({
    required String sellerId,
    required String name,
    required String description,
    required double price,
    required String category,
    List<String> images = const [],
    int stock = 0,
    String? location,
    double? latitude,
    double? longitude,
  }) async {
    final product = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sellerId: sellerId,
      name: name,
      description: description,
      price: price,
      category: category,
      images: images,
      stock: stock,
      isAvailable: true,
      location: location,
      latitude: latitude,
      longitude: longitude,
      createdAt: DateTime.now(),
    );

    await _dbService.insertProduct(product);
    return product;
  }

  // Listar todos os produtos
  Future<List<Product>> getAllProducts({String? category}) async {
    return await _dbService.getAllProducts(category: category);
  }

  // Listar produtos de um vendedor
  Future<List<Product>> getSellerProducts(String sellerId) async {
    return await _dbService.getAllProducts(sellerId: sellerId);
  }

  // Obter produto por ID
  Future<Product?> getProductById(String id) async {
    return await _dbService.getProductById(id);
  }

  // Atualizar produto
  Future<void> updateProduct(Product product) async {
    final updatedProduct = Product(
      id: product.id,
      sellerId: product.sellerId,
      name: product.name,
      description: product.description,
      price: product.price,
      category: product.category,
      images: product.images,
      stock: product.stock,
      isAvailable: product.isAvailable,
      location: product.location,
      latitude: product.latitude,
      longitude: product.longitude,
      createdAt: product.createdAt,
      updatedAt: DateTime.now(),
    );
    await _dbService.updateProduct(updatedProduct);
  }

  // Deletar produto
  Future<void> deleteProduct(String productId) async {
    await _dbService.deleteProduct(productId);
  }

  // Buscar produtos
  Future<List<Product>> searchProducts(String query) async {
    final allProducts = await getAllProducts();
    final queryLower = query.toLowerCase();
    
    return allProducts.where((product) {
      return product.name.toLowerCase().contains(queryLower) ||
          product.description.toLowerCase().contains(queryLower) ||
          product.category.toLowerCase().contains(queryLower);
    }).toList();
  }
}



