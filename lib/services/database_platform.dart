import 'package:flutter/foundation.dart';
import 'database_service.dart';
import 'database_service_web.dart';

// Importação condicional:
// - Em web (dart.library.html existe): usa o stub que define DatabaseServiceNative = DatabaseServiceWeb
// - Em desktop/mobile (dart.library.io existe): usa a implementação real com SQLite
import 'database_service_native.dart' if (dart.library.html) 'database_service_web_stub.dart' as native_impl;

// Factory function para criar o serviço de banco correto
DatabaseService createPlatformDatabaseService() {
  if (kIsWeb) {
    return DatabaseServiceWeb();
  } else {
    // Em desktop/mobile, usar a implementação nativa (SQLite)
    // A importação condicional garante que temos DatabaseServiceNative quando necessário
    return native_impl.DatabaseServiceNative();
  }
}

