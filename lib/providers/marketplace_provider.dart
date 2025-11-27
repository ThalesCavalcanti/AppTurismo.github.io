import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/marketplace_service.dart';

class MarketplaceProvider with ChangeNotifier {
  final MarketplaceService _marketplaceService;
  List<Product> _products = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _error;

  MarketplaceProvider(this._marketplaceService);

  List<Product> get products => _products;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts({String? category, String? sellerId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (sellerId != null) {
        _products = await _marketplaceService.getSellerProducts(sellerId);
      } else {
        _products = await _marketplaceService.getAllProducts(category: category);
      }
    } catch (e) {
      _error = 'Erro ao carregar produtos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProductById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedProduct = await _marketplaceService.getProductById(id);
      if (_selectedProduct == null) {
        _error = 'Produto não encontrado';
      }
    } catch (e) {
      _error = 'Erro ao carregar produto: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createProduct({
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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _marketplaceService.createProduct(
        sellerId: sellerId,
        name: name,
        description: description,
        price: price,
        category: category,
        images: images,
        stock: stock,
        location: location,
        latitude: latitude,
        longitude: longitude,
      );
      await loadProducts(); // Recarregar lista
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erro ao criar produto: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _marketplaceService.updateProduct(product);
      await loadProducts(); // Recarregar lista
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erro ao atualizar produto: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _marketplaceService.deleteProduct(productId);
      await loadProducts(); // Recarregar lista
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erro ao deletar produto: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      return await _marketplaceService.searchProducts(query);
    } catch (e) {
      _error = 'Erro ao buscar produtos: $e';
      notifyListeners();
      return [];
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}



