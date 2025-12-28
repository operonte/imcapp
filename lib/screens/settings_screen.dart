import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import 'about_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _themeMode = 'system';
  String _language = 'es';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final themeMode = await PreferencesService.getThemeMode();
    final language = await PreferencesService.getLanguage();
    setState(() {
      _themeMode = themeMode;
      _language = language;
      _isLoading = false;
    });
  }

  Future<void> _changeThemeMode(String mode) async {
    await PreferencesService.setThemeMode(mode);
    setState(() {
      _themeMode = mode;
    });
    // Notificar al app para que recargue el tema
    if (mounted) {
      Navigator.pop(context, {'themeMode': mode});
    }
  }

  Future<void> _changeLanguage(String language) async {
    await PreferencesService.setLanguage(language);
    setState(() {
      _language = language;
    });
    // Notificar al app para que recargue el idioma
    if (mounted) {
      Navigator.pop(context, {'language': language});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.dark_mode,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Tema',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Selecciona el tema de la aplicación',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    title: const Text('Claro'),
                    leading: Radio<String>(
                      value: 'light',
                      groupValue: _themeMode,
                      onChanged: (value) => _changeThemeMode(value!),
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () => _changeThemeMode('light'),
                  ),
                  ListTile(
                    title: const Text('Oscuro'),
                    leading: Radio<String>(
                      value: 'dark',
                      groupValue: _themeMode,
                      onChanged: (value) => _changeThemeMode(value!),
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () => _changeThemeMode('dark'),
                  ),
                  ListTile(
                    title: const Text('Sistema'),
                    leading: Radio<String>(
                      value: 'system',
                      groupValue: _themeMode,
                      onChanged: (value) => _changeThemeMode(value!),
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () => _changeThemeMode('system'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.language,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Idioma',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Selecciona el idioma de la aplicación',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    title: const Text('Español'),
                    leading: Radio<String>(
                      value: 'es',
                      groupValue: _language,
                      onChanged: (value) => _changeLanguage(value!),
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () => _changeLanguage('es'),
                  ),
                  ListTile(
                    title: const Text('English'),
                    leading: Radio<String>(
                      value: 'en',
                      groupValue: _language,
                      onChanged: (value) => _changeLanguage(value!),
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () => _changeLanguage('en'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Acerca de',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
