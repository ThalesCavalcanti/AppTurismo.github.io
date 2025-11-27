import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String sellerId; // ID do vendedor
  final String name;
  final String description;
  final double price;
  final String category; // artesanato, comida, souvenirs, etc.
  final List<String> images;
  final int stock; // quantidade em estoque
  final bool isAvailable;
  final String? location; // Localização em João Pessoa
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.sellerId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.images = const [],
    this.stock = 0,
    this.isAvailable = true,
    this.location,
    this.latitude,
    this.longitude,
    required this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}



