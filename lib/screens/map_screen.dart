import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/place_provider.dart';
import '../models/place.dart';
import '../config/map_config.dart';
import 'place_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlaceProvider>().loadPlaces();
    });
  }

  void _updateMarkers(List<Place> places) {
    setState(() {
      _markers.clear();
      for (final place in places) {
        _markers.add(
          Marker(
            markerId: MarkerId(place.id),
            position: LatLng(place.latitude, place.longitude),
            infoWindow: InfoWindow(
              title: place.name,
              snippet: place.category,
            ),
            onTap: () {
              context.read<PlaceProvider>().selectPlace(place.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaceDetailScreen(placeId: place.id),
                ),
              );
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Turismo - Paraíba'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Consumer<PlaceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && _markers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  ElevatedButton(
                    onPressed: () => provider.loadPlaces(),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          // Atualizar marcadores quando lugares mudarem
          if (provider.allPlaces.isNotEmpty && _markers.length != provider.allPlaces.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateMarkers(provider.allPlaces);
            });
          }

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    MapConfig.defaultLatitude,
                    MapConfig.defaultLongitude,
                  ),
                  zoom: MapConfig.defaultZoom,
                ),
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
              ),
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    provider.refreshRecommendations();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Recomendações atualizadas!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Icon(Icons.refresh),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}



