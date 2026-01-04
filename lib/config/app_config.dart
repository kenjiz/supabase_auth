import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration class to manage environment variables and app settings
class AppConfig {
  /// Supabase URL from environment
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';

  /// Supabase anonymous key from environment
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// Google Web Client ID for OAuth
  static String get googleWebClientId => dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';

  /// Validate that all required configuration values are present
  static bool validate() {
    if (supabaseUrl.isEmpty) {
      throw Exception('SUPABASE_URL is not set in .env file');
    }
    if (supabaseAnonKey.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY is not set in .env file');
    }
    if (googleWebClientId.isEmpty) {
      throw Exception('GOOGLE_WEB_CLIENT_ID is not set in .env file');
    }
    return true;
  }
}
