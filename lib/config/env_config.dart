import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuración centralizada de variables de entorno
class EnvConfig {
  EnvConfig._(); // private constructor

  /// Entorno actual (dev, prod, etc.)
  static String get env => dotenv.env['APP_ENV'] ?? 'dev';

  /// URL de Supabase
  static String get supabaseUrl {
    final value = dotenv.env['SUPABASE_URL'];
    if (value == null || value.isEmpty) {
      throw Exception('SUPABASE_URL no está definido en el .env');
    }
    return value;
  }

  /// Anon key de Supabase
  static String get supabaseAnonKey {
    final value = dotenv.env['SUPABASE_ANON_KEY'];
    if (value == null || value.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY no está definido en el .env');
    }
    return value;
  }

  /// Base URL de tu RAG_API (asistente del juego)
  static String get ragApiBaseUrl {
    final value = dotenv.env['RAG_API_BASE_URL'];
    if (value == null || value.isEmpty) {
      throw Exception('RAG_API_BASE_URL no está definido en el .env');
    }
    return value;
  }

  /// Ejemplo: otras cosas globales
  static String get appName => dotenv.env['APP_NAME'] ?? 'Zombies: Last Dawn';
}
