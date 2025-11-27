import 'package:flutter/foundation.dart';
import 'database_service.dart';
import 'database_service_web.dart';

// Factory function - para web usa SharedPreferences, para outras plataformas usa SQLite
DatabaseService createDatabaseService() {
  if (kIsWeb) {
    return DatabaseServiceWeb();
  } else {
    // Para plataformas nativas, precisamos importar o serviço SQLite
    // Vamos fazer isso de forma condicional usando um stub
    throw UnimplementedError(
      'Para usar SQLite, importe database_service_native.dart e use DatabaseServiceNative() diretamente'
    );
  }
}
