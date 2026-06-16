# Como Executar o AppTurismo

Este guia assume que você já configurou o projeto. Para instruções de configuração, consulte o arquivo `SETUP.md`.

## Passo 1: Instalar Dependências do Projeto (se ainda não o fez)
Navegue até o diretório do projeto e execute:
```bash
flutter pub get
```

## Passo 2: Executar o App

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
- Para Android: Inicie um emulador ou conecte um dispositivo físico.
- Para Web: Use `flutter run -d chrome`.

### Erro: "Google Maps API Key"
- O app funcionará, mas o mapa não será exibido.
- Configure a API key para ver o mapa funcionando (veja `SETUP.md`).

### Erro: "build_runner"
- Execute: `flutter pub run build_runner build --delete-conflicting-outputs`.

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