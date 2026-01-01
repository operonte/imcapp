import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'saved_users_screen.dart';
import 'settings_screen.dart';
import '../services/auth_service.dart';

class MenuScreen extends StatelessWidget {
  final Function(String)? onThemeChanged;
  final Function(String)? onLanguageChanged;
  final AuthService _authService = AuthService();

  MenuScreen({super.key, this.onThemeChanged, this.onLanguageChanged});

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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar del usuario
                    if (_authService.currentUser != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          backgroundImage: _authService.currentUser!.photoURL != null
                              ? NetworkImage(_authService.currentUser!.photoURL!)
                              : null,
                          child: _authService.currentUser!.photoURL == null
                              ? Text(
                                  _authService.currentUser!.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                                  style: const TextStyle(
                                    color: Color(0xFF1976D2),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    // Botón de configuración
                    IconButton(
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
                  ],
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite,
                size: 80,
                color: Colors.white,
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
      elevation: 12,
      shadowColor: iconColor.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withValues(alpha: 0.95)],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, size: 42, color: iconColor),
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
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.arrow_forward_ios, color: iconColor, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
