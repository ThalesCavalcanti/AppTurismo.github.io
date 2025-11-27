# Guia de Configuração - AppTurismo

## Pré-requisitos

1. **Flutter SDK**: Instale o Flutter (versão 3.0.0 ou superior)
   ```bash
   flutter --version
   ```

2. **Dart SDK**: Incluído com o Flutter

3. **Android Studio / VS Code**: Com extensões Flutter instaladas

## Instalação

1. **Instalar dependências**:
   ```bash
   flutter pub get
   ```

2. **Gerar código** (para serialização JSON):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Configuração do Google Maps

1. **Obter API Key**:
   - Acesse [Google Cloud Console](https://console.cloud.google.com/)
   - Crie um novo projeto ou selecione um existente
   - Ative a API "Maps SDK for Android" e "Maps SDK for iOS"
   - Crie uma credencial (API Key)

2. **Configurar no Android**:
   - Edite `android/app/src/main/AndroidManifest.xml`
   - Substitua `YOUR_GOOGLE_MAPS_API_KEY_HERE` pela sua chave

3. **Configurar no código**:
   - Edite `lib/config/map_config.dart`
   - Substitua `YOUR_GOOGLE_MAPS_API_KEY_HERE` pela sua chave

4. **Para iOS** (se necessário):
   - Edite `ios/Runner/AppDelegate.swift`
   - Adicione sua API key no método `application`

## Executando o App

### Android
```bash
flutter run
```

### Web
```bash
flutter run -d chrome
```

### iOS (apenas no macOS)
```bash
flutter run -d ios
```

## Estrutura do Projeto

```
lib/
├── config/              # Configurações (API keys, etc)
├── models/              # Modelos de dados
│   ├── place.dart
│   ├── user_evaluation.dart
│   └── user_preferences.dart
├── services/            # Serviços (ML, API, Storage)
│   ├── place_service.dart
│   ├── ml_recommendation_service.dart
│   ├── evaluation_service.dart
│   └── storage_service.dart
├── providers/           # State management (Provider)
│   └── place_provider.dart
├── screens/             # Telas do aplicativo
│   ├── map_screen.dart
│   ├── suggestions_screen.dart
│   ├── place_detail_screen.dart
│   └── evaluation_screen.dart
└── main.dart            # Ponto de entrada
```

## Funcionalidades Implementadas

✅ Mapa interativo com Google Maps
✅ Marcadores de pontos turísticos
✅ Sistema de recomendações baseado em ML
✅ Avaliação de lugares pelos usuários
✅ Interface responsiva
✅ Armazenamento local de avaliações

## Próximos Passos (Melhorias Futuras)

- [ ] Integração com API real de lugares
- [ ] Autenticação de usuários
- [ ] Upload de fotos dos lugares
- [ ] Filtros avançados (categoria, distância, preço)
- [ ] Rotas e navegação
- [ ] Compartilhamento de avaliações
- [ ] Modo offline
- [ ] Notificações push

## Notas Importantes

- Os dados de lugares estão mockados em `lib/services/place_service.dart`
- Em produção, substitua por chamadas de API reais
- O algoritmo de ML pode ser melhorado com mais dados e features
- Configure permissões de localização no dispositivo para melhor experiência






