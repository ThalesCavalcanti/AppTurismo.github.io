import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'config/map_config.dart';
import 'providers/place_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/marketplace_provider.dart';
import 'services/place_service.dart';
import 'services/ml_recommendation_service.dart';
import 'services/evaluation_service.dart';
import 'services/storage_service.dart';
import 'services/database_platform.dart';
import 'services/auth_service.dart';
import 'services/marketplace_service.dart';
import 'services/passport_service.dart';
import 'providers/passport_provider.dart';
import 'screens/map_screen.dart';
import 'screens/suggestions_screen.dart';
import 'screens/login_screen.dart';
import 'screens/marketplace_screen.dart';
import 'screens/digital_passport_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar sqflite para desktop (não funciona em web)
  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    // Para mobile (Android/iOS), o sqflite já está configurado automaticamente
  } else {
    // Para web, usar SharedPreferences (já configurado)
    debugPrint('✅ Modo Web: Usando SharedPreferences para armazenamento');
  }
  
  // Verificar se a API key está configurada
  if (MapConfig.googleMapsApiKey == 'YOUR_GOOGLE_MAPS_API_KEY_HERE') {
    debugPrint('⚠️ ATENÇÃO: Configure sua Google Maps API Key em lib/config/map_config.dart');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicializar serviços - usar SharedPreferences para web, SQLite para nativo
    final databaseService = createPlatformDatabaseService();
    final storageService = StorageService();
    final evaluationService = EvaluationService(storageService);
    final placeService = PlaceService();
    final mlService = MLRecommendationService(evaluationService);
    final authService = AuthService(databaseService);
    final marketplaceService = MarketplaceService(databaseService);
    final passportService = PassportService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PlaceProvider(
            placeService,
            mlService,
            evaluationService,
            storageService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService),
        ),
        ChangeNotifierProvider(
          create: (_) => MarketplaceProvider(marketplaceService),
        ),
        ChangeNotifierProvider(
          create: (_) => PassportProvider(passportService),
        ),
      ],
      child: MaterialApp(
        title: 'AppTurismo - Paraíba',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        routes: {
          '/home': (context) => const MainScreen(),
          '/login': (context) => const LoginScreen(),
        },
        home: const AuthWrapper(),
      ),
    );
  }
}

// Wrapper para verificar autenticação
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.canAccessApp) {
          return const MainScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isGuest = authProvider.isGuest;
    final isAuthenticated = authProvider.isAuthenticated;

    // Definir telas baseado no tipo de usuário
    final List<Widget> screens = isGuest
        ? [
            const MapScreen(),
            const SuggestionsScreen(),
            const DigitalPassportScreen(),
          ]
        : [
            const MapScreen(),
            const SuggestionsScreen(),
            const MarketplaceScreen(),
            const DigitalPassportScreen(),
          ];

    // Limitar índice para convidados
    if (isGuest && _currentIndex >= screens.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          // Se for convidado tentando acessar marketplace
          if (isGuest && index == 2) {
            _showLoginRequiredDialog(context);
            return;
          }
          // Se for usuário logado tentando acessar marketplace (índice 2)
          if (!isGuest && index == 2) {
            setState(() {
              _currentIndex = index;
            });
            return;
          }
          // Se for passaporte (índice 3 para logado, índice 2 para guest)
          if ((!isGuest && index == 3) || (isGuest && index == 2)) {
            setState(() {
              _currentIndex = index;
            });
            // Carregar passaporte se necessário
            final authProvider = context.read<AuthProvider>();
            if (!authProvider.isGuest && authProvider.isAuthenticated) {
              context.read<PassportProvider>().loadPassport(authProvider.currentUser!.id);
            }
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Mapa',
          ),
          const NavigationDestination(
            icon: Icon(Icons.recommend_outlined),
            selectedIcon: Icon(Icons.recommend),
            label: 'Sugestões',
          ),
          NavigationDestination(
            icon: Icon(isGuest ? Icons.lock_outline : Icons.shopping_bag_outlined),
            selectedIcon: Icon(isGuest ? Icons.lock : Icons.shopping_bag),
            label: 'Marketplace',
            tooltip: isGuest ? 'Login necessário' : 'Marketplace',
          ),
          const NavigationDestination(
            icon: Icon(Icons.card_membership_outlined),
            selectedIcon: Icon(Icons.card_membership),
            label: 'Passaporte',
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('AppTurismo - Paraíba'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton(
            icon: Icon(isGuest ? Icons.person_outline : Icons.person),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(isGuest ? Icons.explore : Icons.person, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      isGuest
                          ? 'Modo Turista'
                          : authProvider.currentUser?.name ?? 'Usuário',
                    ),
                  ],
                ),
              ),
              if (isAuthenticated && authProvider.isSeller)
                const PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.store, size: 20),
                      SizedBox(width: 8),
                      Text('Vendedor'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'passport',
                child: Row(
                  children: [
                    Icon(Icons.card_membership, size: 20),
                    SizedBox(width: 8),
                    Text('Passaporte Digital'),
                  ],
                ),
              ),
              if (isGuest)
                const PopupMenuItem(
                  value: 'login',
                  child: Row(
                    children: [
                      Icon(Icons.login, size: 20),
                      SizedBox(width: 8),
                      Text('Fazer Login / Cadastrar'),
                    ],
                  ),
                ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      isGuest ? Icons.exit_to_app : Icons.logout,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(isGuest ? 'Voltar ao Login' : 'Sair'),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'login' && isGuest) {
                await authProvider.logout();
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              } else if (value == 'passport') {
                setState(() {
                  _currentIndex = isGuest ? 2 : 3; // Índice do passaporte
                });
              } else if (value == 'logout') {
                await authProvider.logout();
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lock, color: Colors.orange),
            SizedBox(width: 8),
            Text('Login Necessário'),
          ],
        ),
        content: const Text(
          'O Marketplace está disponível apenas para usuários cadastrados. '
          'Faça login ou crie uma conta para acessar e vender produtos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
            ),
            child: const Text('Fazer Login'),
          ),
        ],
      ),
    );
  }
}
