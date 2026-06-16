# Guia de Configuração - AppTurismo

## Pré-requisitos

1. **Flutter SDK**: Instale o Flutter (versão 3.0.0 ou superior).
   ```bash
   flutter --version
   ```

2. **Ambiente de Desenvolvimento**: Android Studio ou VS Code com as extensões do Flutter instaladas.

## Instalação do Projeto

1. **Clonar o Repositório** (se ainda não o fez):
   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd AppTurismo
   ```

2. **Instalar Dependências**:
   ```bash
   flutter pub get
   ```

3. **Gerar Código de Serialização JSON**:
   Este passo é necessário para os modelos de dados do aplicativo.
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Configuração do Google Maps

Para que o mapa interativo funcione, você precisa de uma chave de API do Google Maps.

1. **Obter uma Chave de API**:
   - Acesse o [Console do Google Cloud](https://console.cloud.google.com/).
   - Crie um novo projeto ou selecione um existente.
   - No menu de navegação, vá para "APIs e Serviços" > "Biblioteca".
   - Ative as seguintes APIs:
     - **Maps SDK for Android**
     - **Maps SDK for iOS** (se for desenvolver para iOS)
     - **Maps JavaScript API** (para a versão web)
   - Vá para "APIs e Serviços" > "Credenciais" e crie uma nova "Chave de API".
   - **RECOMENDAÇÃO**: Restrinja sua chave de API para evitar o uso não autorizado. Para este projeto, você pode restringi-la para Android, iOS e Web.

2. **Configurar a Chave no Projeto**:
   - **Crie o arquivo de configuração**:
     - Renomeie (ou copie) o arquivo `lib/config/map_config.dart.example` para `lib/config/map_config.dart`.
   - **Adicione a chave no código**:
     - Abra o arquivo `lib/config/map_config.dart`.
     - Substitua o valor `YOUR_GOOGLE_MAPS_API_KEY_HERE` pela chave que você criou.

3. **Configurar para Android**:
   - Abra o arquivo `android/app/src/main/AndroidManifest.xml`.
   - Encontre a linha que diz `<!-- TODO: Add your Google Maps API key here -->`.
   - Adicione o seguinte meta-data com a sua chave:
     ```xml
     <meta-data
         android:name="com.google.android.geo.API_KEY"
         android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"/>
     ```

4. **Configurar para Web**:
   - Abra o arquivo `web/index.html`.
   - Encontre a linha que diz `<!-- TODO: Add your Google Maps API key here -->`.
   - Adicione o seguinte script antes do fechamento da tag `</head>`:
     ```html
     <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_GOOGLE_MAPS_API_KEY_HERE"></script>
     ```

## Próximos Passos

Após a configuração, você está pronto para executar o aplicativo. Consulte o `RUN_GUIDE.md` para instruções detalhadas.
