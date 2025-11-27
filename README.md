# AppTurismo - Paraíba 🇧🇷

Aplicativo híbrido (mobile/web) em Flutter para turismo no estado da Paraíba, Brasil. Utiliza algoritmos de Machine Learning para sugerir lugares turísticos baseados nas preferências e avaliações dos usuários.

## ✨ Funcionalidades

- 🗺️ **Mapa Interativo**: Visualização de pontos turísticos no Google Maps
- 🤖 **Sugestões Inteligentes**: Recomendações personalizadas usando ML
- ⭐ **Sistema de Avaliação**: Usuários podem avaliar e comentar sobre lugares
- 📍 **Pontos de Referência**: Marcadores no mapa para fácil navegação
- 💾 **Armazenamento Local**: Avaliações salvas localmente no dispositivo
- 📱 **Interface Responsiva**: Funciona em Android, iOS e Web

## 🚀 Início Rápido

### Pré-requisitos

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Google Maps API Key ([Como obter](https://console.cloud.google.com/))

### Instalação

1. **Instalar dependências**:
   ```bash
   flutter pub get
   ```

2. **Gerar código de serialização**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Configurar Google Maps API Key**:
   - Edite `lib/config/map_config.dart`
   - Substitua `YOUR_GOOGLE_MAPS_API_KEY_HERE` pela sua chave
   - Edite `android/app/src/main/AndroidManifest.xml` e adicione a mesma chave

4. **Executar o app**:
   ```bash
   flutter run
   ```

## 📁 Estrutura do Projeto

```
lib/
├── config/              # Configurações (API keys, constantes)
│   ├── map_config.dart
│   └── map_config.dart.example
├── models/              # Modelos de dados
│   ├── place.dart              # Modelo de lugar turístico
│   ├── user_evaluation.dart    # Modelo de avaliação
│   └── user_preferences.dart    # Preferências do usuário
├── services/            # Lógica de negócio
│   ├── place_service.dart              # Serviço de lugares
│   ├── ml_recommendation_service.dart  # Algoritmo de ML
│   ├── evaluation_service.dart         # Gerenciamento de avaliações
│   └── storage_service.dart            # Armazenamento local
├── providers/           # State Management (Provider pattern)
│   └── place_provider.dart
├── screens/             # Telas do aplicativo
│   ├── map_screen.dart           # Tela do mapa
│   ├── suggestions_screen.dart   # Tela de sugestões
│   ├── place_detail_screen.dart  # Detalhes do lugar
│   └── evaluation_screen.dart    # Tela de avaliação
└── main.dart            # Ponto de entrada
```

## 🧠 Algoritmo de Recomendação (ML)

O sistema de recomendações utiliza um algoritmo híbrido que considera:

1. **Preferências do Usuário** (30 pontos): Categorias preferidas
2. **Avaliação Média** (30 pontos): Rating geral do lugar
3. **Popularidade** (20 pontos): Número de avaliações
4. **Distância** (20 pontos): Proximidade do usuário
5. **Diversidade**: Penaliza lugares já avaliados pelo usuário

## 📱 Telas

- **Mapa**: Visualização interativa com marcadores dos lugares
- **Sugestões**: Lista de lugares recomendados pelo algoritmo ML
- **Detalhes**: Informações completas sobre um lugar
- **Avaliação**: Interface para avaliar e comentar sobre lugares

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework multiplataforma
- **Google Maps**: Integração de mapas
- **Provider**: Gerenciamento de estado
- **SharedPreferences**: Armazenamento local
- **JSON Serialization**: Serialização de dados

## 📝 Notas

- Os dados de lugares estão mockados em `lib/services/place_service.dart`
- Em produção, substitua por chamadas de API reais
- O algoritmo ML pode ser melhorado com mais features e dados
- Configure permissões de localização para melhor experiência

## 📖 Documentação Adicional

Consulte `SETUP.md` para instruções detalhadas de configuração.

## 📄 Licença

Este projeto é de código aberto.

