import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../providers/place_provider.dart';
import '../providers/passport_provider.dart';
import '../providers/auth_provider.dart';
import 'evaluation_screen.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String placeId;

  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaceProvider>().selectPlace(widget.placeId);
      // Carregar passaporte se usuário estiver autenticado
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated && !authProvider.isGuest) {
        context.read<PassportProvider>().loadPassport(authProvider.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Lugar'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Consumer<PlaceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final place = provider.selectedPlace;
          if (place == null) {
            return const Center(child: Text('Lugar não encontrado'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Imagem (placeholder)
                Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (place.averageRating != null) ...[
                            RatingBarIndicator(
                              rating: place.averageRating!,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              place.averageRating!.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (place.totalRatings != null) ...[
                              const SizedBox(width: 4),
                              Text(
                                '(${place.totalRatings} avaliações)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (place.address != null) ...[
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                place.address!,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      Chip(
                        label: Text(place.category.toUpperCase()),
                        backgroundColor: Colors.blue[100],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Descrição',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        place.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      // Botão de Check-in
                      Consumer2<PassportProvider, AuthProvider>(
                        builder: (context, passportProvider, authProvider, child) {
                          if (authProvider.isGuest) {
                            return const SizedBox.shrink();
                          }

                          final hasVisited = passportProvider.hasVisitedPlace(place.id);
                          final userId = authProvider.currentUser?.id;

                          if (userId == null) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: hasVisited
                                      ? null
                                      : () => _handleCheckIn(context, passportProvider, userId, place),
                                  icon: Icon(hasVisited ? Icons.check_circle : Icons.location_on),
                                  label: Text(hasVisited ? 'Check-in Realizado ✓' : 'Fazer Check-in'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: hasVisited ? Colors.green : Colors.orange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    disabledBackgroundColor: Colors.green[300],
                                  ),
                                ),
                              ),
                              if (hasVisited) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.celebration, color: Colors.green),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Você ganhou um sel!',
                                        style: TextStyle(
                                          color: Colors.green[900],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EvaluationScreen(placeId: place.id),
                              ),
                            );
                            if (result == true) {
                              // Recarregar lugar para atualizar avaliações
                              provider.selectPlace(place.id);
                            }
                          },
                          icon: const Icon(Icons.star),
                          label: const Text('Avaliar este lugar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleCheckIn(BuildContext context, PassportProvider passportProvider,
      String userId, dynamic place) async {
    final success = await passportProvider.checkIn(
      userId,
      place.id,
      latitude: place.latitude,
      longitude: place.longitude,
    );

    if (success && context.mounted) {
      // Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.celebration, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text('Check-in realizado! Você ganhou um sel! 🎉'),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Ver Passaporte',
            textColor: Colors.white,
            onPressed: () {
              // Navegar para o passaporte - será implementado depois
            },
          ),
        ),
      );
    } else if (context.mounted && passportProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(passportProvider.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}




