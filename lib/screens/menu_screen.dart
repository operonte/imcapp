import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'saved_users_screen.dart';
import 'settings_screen.dart';

class MenuScreen extends StatelessWidget {
  final Function(String)? onThemeChanged;
  final Function(String)? onLanguageChanged;

  const MenuScreen({super.key, this.onThemeChanged, this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    const Color(0xFF353535),
                    const Color(0xFF424242),
                  ]
                : [
                    Colors.blue.shade400,
                    Colors.teal.shade400,
                  ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildMainContent(context),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                    if (result != null) {
                      if (result['themeMode'] != null) {
                        onThemeChanged?.call(result['themeMode']);
                      }
                      if (result['language'] != null) {
                        onLanguageChanged?.call(result['language']);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Título y logo
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite,
                size: 80,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Calculadora IMC',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Gestiona tu salud',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 60),
            // Botón Nuevo Ingreso
            _buildMenuCard(
              context,
              title: 'Nuevo Ingreso',
              subtitle: 'Calcular y guardar nuevo IMC',
              icon: Icons.add_circle_outline,
              color: Colors.white,
              iconColor: const Color(0xFF1976D2),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            const SizedBox(height: 24),
            // Botón Guardados
            _buildMenuCard(
              context,
              title: 'Guardados',
              subtitle: 'Ver usuarios y sus registros',
              icon: Icons.people_outline,
              color: Colors.white,
              iconColor: const Color(0xFF4CAF50),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SavedUsersScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withValues(alpha: 0.95)],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 40, color: iconColor),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: iconColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
