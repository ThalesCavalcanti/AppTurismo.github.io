import 'package:flutter/foundation.dart';
import 'database_service.dart';
import 'database_service_web.dart';

// Factory helper para criar o serviço de banco correto
DatabaseService createDatabaseServiceForPlatform() {
  if (kIsWeb) {
    return DatabaseServiceWeb();
  } else {
    // Para desktop/mobile, importar dinamicamente
    // Esta função será sobrescrita quando não for web
    return _createNativeService();
  }
}

// Esta função será substituída pela implementação real em database_service_native.dart
DatabaseService _createNativeService() {
  throw UnimplementedError(
    'DatabaseServiceNative não disponível. '
    'Certifique-se de que database_service_native.dart está importado.'
  );
}



