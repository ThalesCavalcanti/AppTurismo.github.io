import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isGuest = false;

  AuthProvider(this._authService);

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isGuest => _isGuest;
  bool get canAccessApp => isAuthenticated || _isGuest;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSeller => _currentUser?.isSeller ?? false;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.login(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
    bool isSeller = false,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
        isSeller: isSeller,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void setGuestMode(bool isGuest) {
    _isGuest = isGuest;
    if (isGuest) {
      _currentUser = null;
      _error = null;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    _isGuest = false;
    _error = null;
    notifyListeners();
  }

  Future<void> loadUser(String userId) async {
    try {
      _currentUser = await _authService.getUserById(userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

