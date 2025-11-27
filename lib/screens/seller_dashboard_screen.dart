import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/marketplace_provider.dart';
import '../providers/auth_provider.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';
import 'add_product_screen.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Produtos'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar Produto',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddProductScreen(),
                ),
              ).then((_) {
                context.read<MarketplaceProvider>().loadProducts(
                      sellerId: authProvider.currentUser?.id,
                    );
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: () async {
          final provider = context.read<MarketplaceProvider>();
          await provider.loadProducts(
            sellerId: authProvider.currentUser?.id,
          );
        }(),
        builder: (context, snapshot) {
          return Consumer<MarketplaceProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(provider.error!),
                      ElevatedButton(
                        onPressed: () => provider.loadProducts(
                          sellerId: authProvider.currentUser?.id,
                        ),
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                );
              }

              if (provider.products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inventory_2, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Você ainda não tem produtos',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddProductScreen(),
                            ),
                          ).then((_) {
                            provider.loadProducts(
                              sellerId: authProvider.currentUser?.id,
                            );
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar Primeiro Produto'),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.products.length,
                itemBuilder: (context, index) {
                  final product = provider.products[index];
                  return _SellerProductCard(product: product);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _SellerProductCard extends StatelessWidget {
  final Product product;

  const _SellerProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final marketplaceProvider = context.read<MarketplaceProvider>();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: product.images.isEmpty
              ? const Icon(Icons.image, color: Colors.grey)
              : Image.network(
                  product.images.first,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image, color: Colors.grey),
                ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('R\$ ${product.price.toStringAsFixed(2)}'),
            Text(
              'Estoque: ${product.stock} | ${product.category}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Excluir', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) async {
            if (value == 'edit') {
              // TODO: Implementar edição
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade de edição em breve'),
                ),
              );
            } else if (value == 'delete') {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar exclusão'),
                  content: Text('Deseja realmente excluir "${product.name}"?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                final success = await marketplaceProvider.deleteProduct(product.id);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Produto excluído com sucesso'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            }
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(productId: product.id),
            ),
          );
        },
      ),
    );
  }
}



