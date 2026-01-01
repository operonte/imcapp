import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/menu_screen.dart';
import 'screens/login_screen.dart';
import 'services/preferences_service.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _themeMode = 'system';
  String _language = 'es';
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final themeMode = await PreferencesService.getThemeMode();
    final language = await PreferencesService.getLanguage();
    setState(() {
      _themeMode = themeMode;
      _language = language;
    });
  }

  void _updateTheme(String themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  ThemeMode _getThemeMode() {
    switch (_themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  void _updateLanguage(String language) {
    setState(() {
      _language = language;
    });
  }

  ThemeData _getLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4A90E2),
        primary: const Color(0xFF4A90E2),
        secondary: const Color(0xFF50C878),
        surface: Colors.white,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A90E2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
      ),
    );
  }

  ThemeData _getDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF64B5F6),
        primary: const Color(0xFF64B5F6),
        secondary: const Color(0xFF81C784),
        surface: const Color(0xFF424242),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF353535),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF64B5F6),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        color: const Color(0xFF424242),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: const Color(0xFF4A4A4A),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
        bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
        bodySmall: TextStyle(color: Color(0xFFB0B0B0)),
        titleLarge: TextStyle(color: Color(0xFFFFFFFF)),
        titleMedium: TextStyle(color: Color(0xFFFFFFFF)),
        titleSmall: TextStyle(color: Color(0xFFE0E0E0)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF64B5F6),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora IMC',
      debugShowCheckedModeBanner: false,
      theme: _getLightTheme(),
      darkTheme: _getDarkTheme(),
      themeMode: _getThemeMode(),
      locale: Locale(_language),
      home: StreamBuilder(
        stream: _authService.authStateChanges,
        builder: (context, snapshot) {
          // Mostrar loading mientras verifica autenticación
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue.shade400, Colors.teal.shade400],
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            );
          }

          // Si el usuario está autenticado, mostrar MenuScreen
          if (snapshot.hasData && snapshot.data != null) {
            return MenuScreen(
              onThemeChanged: _updateTheme,
              onLanguageChanged: _updateLanguage,
            );
          }

          // Si no está autenticado, mostrar LoginScreen
          return const LoginScreen();
        },
      ),
    );
  }
}
