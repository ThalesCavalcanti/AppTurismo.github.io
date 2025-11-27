// Stub para web - quando compilado para web, este arquivo substitui database_service_native.dart
import 'database_service_web.dart';

// Em web, DatabaseServiceNative é apenas um alias para DatabaseServiceWeb
// Isso permite que o código compile mesmo quando SQLite não está disponível
typedef DatabaseServiceNative = DatabaseServiceWeb;



