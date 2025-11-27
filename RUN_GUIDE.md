# Como Executar o AppTurismo

## Passo 1: Instalar Flutter

### Opção A: Via Snap (Recomendado para Linux)
```bash
sudo snap install flutter --classic
```

### Opção B: Instalação Manual
1. Baixe o Flutter SDK: https://flutter.dev/docs/get-started/install/linux
2. Extraia o arquivo e adicione ao PATH:
   ```bash
   export PATH="$PATH:/caminho/para/flutter/bin"
   ```

### Verificar Instalação
```bash
flutter doctor
```

## Passo 2: Instalar Dependências do Projeto

```bash
cd /home/thales/Documents/AppTurismo
flutter pub get
```

## Passo 3: Gerar Código de Serialização

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Passo 4: Configurar Google Maps API Key (Opcional para Teste)

⚠️ **Nota**: O app funcionará mesmo sem a API key, mas o mapa não será exibido.

Para configurar:
1. Edite `lib/config/map_config.dart`
2. Substitua `YOUR_GOOGLE_MAPS_API_KEY_HERE` pela sua chave
3. Edite `android/app/src/main/AndroidManifest.xml` e adicione a mesma chave

## Passo 5: Executar o App

### Verificar Dispositivos Disponíveis
```bash
flutter devices
```

### Executar no Android (se tiver emulador/dispositivo)
```bash
flutter run
```

### Executar na Web (Chrome)
```bash
flutter run -d chrome
```

### Executar em Modo Web (sem precisar de dispositivo)
```bash
flutter run -d web-server --web-port=8080
```

## Solução de Problemas

### Erro: "No devices found"
- Para Android: Inicie um emulador ou conecte um dispositivo físico
- Para Web: Use `flutter run -d chrome`

### Erro: "Google Maps API Key"
- O app funcionará, mas o mapa não será exibido
- Configure a API key para ver o mapa funcionando

### Erro: "build_runner"
- Execute: `flutter pub run build_runner build --delete-conflicting-outputs`

## Comandos Úteis

```bash
# Verificar status do Flutter
flutter doctor

# Limpar build
flutter clean

# Atualizar dependências
flutter pub upgrade

# Ver logs em tempo real
flutter logs
```






