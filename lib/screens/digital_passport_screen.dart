import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/passport_provider.dart';
import '../models/stamp.dart';

class DigitalPassportScreen extends StatelessWidget {
  const DigitalPassportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passaporte Digital'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Consumer<PassportProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PassportHeader(stats: provider.stats),
                const SizedBox(height: 24),
                const Text(
                  'Meus Selos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (provider.collectedStamps.isEmpty)
                  _EmptyPassportState()
                else
                  _StampsGrid(stamps: provider.collectedStamps),
                const SizedBox(height: 24),
                const Text(
                  'Todos os Selos Disponíveis',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _AllStampsGrid(
                  allStamps: provider.allStamps,
                  collectedIds: provider.collectedStampIds,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PassportHeader extends StatelessWidget {
  final Map<String, dynamic> stats;

  const _PassportHeader({required this.stats});

  @override
  Widget build(BuildContext context) {
    final completionPercentage = stats['completionPercentage'] as int? ?? 0;
    final totalStamps = stats['totalStamps'] as int? ?? 0;
    final totalPlaces = stats['totalPlaces'] as int? ?? 0;
    final totalAvailable = stats['totalAvailable'] as int? ?? 0;

    return Card(
      elevation: 4,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.card_membership, size: 60, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Passaporte Digital',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'João Pessoa - Paraíba',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.location_on,
                  label: 'Lugares',
                  value: '$totalPlaces',
                ),
                _StatItem(
                  icon: Icons.stars,
                  label: 'Selos',
                  value: '$totalStamps/$totalAvailable',
                ),
                _StatItem(
                  icon: Icons.percent,
                  label: 'Completo',
                  value: '$completionPercentage%',
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: completionPercentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue[700], size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _EmptyPassportState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Icon(Icons.explore_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Seu passaporte está vazio',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Faça check-in nos lugares que visitar para coletar selos!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _StampsGrid extends StatelessWidget {
  final List<Stamp> stamps;

  const _StampsGrid({required this.stamps});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: stamps.length,
      itemBuilder: (context, index) {
        final stamp = stamps[index];
        return _StampCard(stamp: stamp, isCollected: true);
      },
    );
  }
}

class _AllStampsGrid extends StatelessWidget {
  final List<Stamp> allStamps;
  final List<String> collectedIds;

  const _AllStampsGrid({
    required this.allStamps,
    required this.collectedIds,
  });

  @override
  Widget build(BuildContext context) {
    if (allStamps.isEmpty) {
      return const Center(
        child: Text('Nenhum selo disponível no momento'),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: allStamps.length,
      itemBuilder: (context, index) {
        final stamp = allStamps[index];
        final isCollected = collectedIds.contains(stamp.id);
        return _StampCard(stamp: stamp, isCollected: isCollected);
      },
    );
  }
}

class _StampCard extends StatelessWidget {
  final Stamp stamp;
  final bool isCollected;

  const _StampCard({
    required this.stamp,
    required this.isCollected,
  });

  Color _getRarityColor() {
    switch (stamp.rarity) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _StampDetailDialog(stamp: stamp, isCollected: isCollected),
        );
      },
      child: Card(
        elevation: isCollected ? 4 : 1,
        color: isCollected ? Colors.white : Colors.grey[200],
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isCollected
                ? Border.all(color: _getRarityColor(), width: 2)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                stamp.icon,
                style: const TextStyle(fontSize: 40),
              ),
              if (!isCollected) ...[
                const SizedBox(height: 4),
                Icon(
                  Icons.lock,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StampDetailDialog extends StatelessWidget {
  final Stamp stamp;
  final bool isCollected;

  const _StampDetailDialog({
    required this.stamp,
    required this.isCollected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              stamp.icon,
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 16),
            Text(
              stamp.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              stamp.description,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            if (!isCollected)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      'Selo ainda não coletado',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }
}

