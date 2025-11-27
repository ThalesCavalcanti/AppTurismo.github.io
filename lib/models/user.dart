import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  final String password; // Em produção, usar hash
  final String? phone;
  final String? address;
  final bool isSeller; // Se é vendedor no marketplace
  final DateTime createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.address,
    this.isSeller = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  
  // Remover senha antes de enviar para o cliente
  Map<String, dynamic> toJsonWithoutPassword() {
    final json = toJson();
    json.remove('password');
    return json;
  }
}



