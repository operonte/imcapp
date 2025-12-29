import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _themeModeKey = 'theme_mode';
  static const String _languageKey = 'language';

  // Modo de tema: 'light', 'dark', 'system'
  static Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_themeModeKey);
    // Migración: si hay un bool antiguo, convertirlo
    if (value == null) {
      final oldBool = prefs.getBool('dark_mode');
      if (oldBool != null) {
        await prefs.remove('dark_mode');
        return oldBool ? 'dark' : 'light';
      }
    }
    return value ?? 'system';
  }

  static Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode);
  }

  // Idioma
  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'es';
  }

  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
}
