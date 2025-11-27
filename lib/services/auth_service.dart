import '../models/user.dart';
import 'database_service.dart';

class AuthService {
  final DatabaseService _dbService;

  AuthService(this._dbService);

  // Registrar novo usuário
  Future<User> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
    bool isSeller = false,
  }) async {
    // Verificar se email já existe
    final existingUser = await _dbService.getUserByEmail(email);
    if (existingUser != null) {
      throw Exception('Email já está em uso');
    }

    // Criar novo usuário
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password, // Em produção, usar hash (bcrypt)
      phone: phone,
      address: address,
      isSeller: isSeller,
      createdAt: DateTime.now(),
    );

    await _dbService.insertUser(user);
    return user;
  }

  // Login
  Future<User> login(String email, String password) async {
    final user = await _dbService.getUserByEmail(email);
    
    if (user == null) {
      throw Exception('Email não encontrado');
    }

    if (user.password != password) {
      throw Exception('Senha incorreta');
    }

    return user;
  }

  // Obter usuário por ID
  Future<User?> getUserById(String id) async {
    return await _dbService.getUserById(id);
  }

  // Atualizar perfil do usuário
  Future<void> updateProfile(User user) async {
    final updatedUser = User(
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
      phone: user.phone,
      address: user.address,
      isSeller: user.isSeller,
      createdAt: user.createdAt,
      updatedAt: DateTime.now(),
    );
    await _dbService.updateUser(updatedUser);
  }
}



