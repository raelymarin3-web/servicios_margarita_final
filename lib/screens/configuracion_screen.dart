import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../configuracion_provider.dart';
import 'login_screen.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConfiguracionProvider>(
      builder: (context, config, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('⚙️ Configuración'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // APARIENCIA
              _buildSectionHeader('APARIENCIA'),
              _buildOptionRow(
                icon: Icons.palette,
                title: 'Tema',
                subtitle: config.tema,
                onTap: () => _showThemeDialog(context, config),
              ),
              _buildOptionRow(
                icon: Icons.language,
                title: 'Idioma',
                subtitle: config.idioma,
                onTap: () => _showLanguageDialog(context, config),
              ),
              const Divider(height: 24),

              // NOTIFICACIONES
              _buildSectionHeader('NOTIFICACIONES'),
              _buildSwitchRow(
                icon: Icons.notifications,
                title: 'Activar notificaciones',
                value: config.notificaciones,
                onChanged: (value) => config.setNotificaciones(value),
              ),
              _buildSwitchRow(
                icon: Icons.volume_up,
                title: 'Sonido',
                value: config.sonido,
                onChanged: (value) => config.setSonido(value),
              ),
              _buildSwitchRow(
                icon: Icons.vibration,
                title: 'Vibración',
                value: config.vibracion,
                onChanged: (value) => config.setVibracion(value),
              ),
              const Divider(height: 24),

              // PRIVACIDAD
              _buildSectionHeader('PRIVACIDAD'),
              _buildSwitchRow(
                icon: Icons.phone,
                title: 'Mostrar mi teléfono',
                value: config.mostrarTelefono,
                onChanged: (value) => config.setMostrarTelefono(value),
              ),
              _buildSwitchRow(
                icon: Icons.location_on,
                title: 'Mostrar mi ubicación',
                value: config.mostrarUbicacion,
                onChanged: (value) => config.setMostrarUbicacion(value),
              ),
              const Divider(height: 24),

              // ACERCA DE
              _buildSectionHeader('ACERCA DE'),
              _buildInfoRow(
                icon: Icons.info,
                title: 'Versión',
                subtitle: '1.0.0',
              ),
              _buildInfoRow(
                icon: Icons.email,
                title: 'Contacto',
                subtitle: 'serviciosmargarita@gmail.com'
              ),
              const Divider(height: 24),

              // ============================================
              // BOTÓN CERRAR SESIÓN - CORREGIDO
              // ============================================
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('🚪 Cerrar Sesión'),
                ),
              ),
              const SizedBox(height: 20),

              // Versión
              Center(
                child: Text(
                  'Servicios Margarita v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildOptionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
      onTap: () => onChanged(!value),
    );
  }

  void _showThemeDialog(BuildContext context, ConfiguracionProvider config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecciona un tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('☀️ Claro'),
              onTap: () {
                config.setTema('Claro');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('🌙 Oscuro'),
              onTap: () {
                config.setTema('Oscuro');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('⚡ Sistema'),
              onTap: () {
                config.setTema('Sistema');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, ConfiguracionProvider config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecciona un idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('🇪🇸 Español'),
              onTap: () {
                config.setIdioma('Español');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('🇺🇸 English'),
              onTap: () {
                config.setIdioma('English');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // ✅ CERRAR SESIÓN - CORREGIDO
  // ============================================
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              // Navegar al Login y eliminar el historial
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false, // Elimina todas las rutas anteriores
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}