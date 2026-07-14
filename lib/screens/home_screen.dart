import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../configuracion_provider.dart';
import 'buscar_servicios_screen.dart';
import 'seleccion_tipo_servicio_screen.dart';
import 'patrocinadores_screen.dart';
import 'mis_servicios_screen.dart';
import 'perfil_usuario_screen.dart';
import 'apoyanos_screen.dart';
import 'configuracion_screen.dart';
import '../widgets/drawer_menu.dart';  // ← NUEVA IMPORTACIÓN

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfiguracionProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: 'Menú',
          ),
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/logo.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Servicios Margarita'),
          ],
        ),
      ),
      drawer: const DrawerMenu(),  // ← CAMBIO: Usa el widget reutilizable
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ============================================
            // LOGO CENTRAL
            // ============================================
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  'assets/logo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ============================================
            // TEXTO DE BIENVENIDA
            // ============================================
            const Text(
              '¡Bienvenido!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '¿Qué necesitas hoy?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),

            // ============================================
            // BOTÓN: BUSCAR SERVICIOS
            // ============================================
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BuscarServiciosScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.search, size: 28),
              label: const Text(
                'Buscar Servicios',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                side: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            const SizedBox(height: 16),

            // ============================================
            // BOTÓN: OFRECER SERVICIOS
            // ============================================
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SeleccionTipoServicioScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add_business, size: 28),
              label: const Text(
                'Ofrecer Servicios',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                side: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            const SizedBox(height: 16),

            // ============================================
            // BOTÓN: ALIADOS DE MARGARITA
            // ============================================
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PatrocinadoresScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.emoji_events, size: 28, color: Colors.amber),
              label: const Text(
                '⭐ Aliados de Margarita',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.amber,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                side: const BorderSide(color: Colors.amber, width: 2),
              ),
            ),
            const SizedBox(height: 40),

            // ============================================
            // VERSIÓN
            // ============================================
            const Text(
              'Versión 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}