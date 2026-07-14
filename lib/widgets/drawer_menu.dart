import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/buscar_servicios_screen.dart';
import '../screens/seleccion_tipo_servicio_screen.dart';
import '../screens/mis_servicios_screen.dart';
import '../screens/perfil_usuario_screen.dart';
import '../screens/patrocinadores_screen.dart';
import '../screens/configuracion_screen.dart';
import '../screens/apoyanos_screen.dart';
import 'compartir_app.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.blue,
            child: Column(
              children: [
                const SizedBox(height: 30),
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Servicios Margarita',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Conectamos la isla',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // OPCIONES
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // 1. MI PERFIL
                Material(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.person, color: isDark ? Colors.white : Colors.black),
                    title: Text('Mi Perfil', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PerfilUsuarioScreen()),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                  ),
                ),
                Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),

                // 2. INICIO
                Material(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.home, color: isDark ? Colors.white : Colors.black),
                    title: Text('Inicio', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                  ),
                ),
                Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),

                // 3. BUSCAR SERVICIOS
                Material(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.search, color: isDark ? Colors.white : Colors.black),
                    title: Text('Buscar Servicios', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BuscarServiciosScreen()),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                  ),
                ),

                // 4. OFRECER SERVICIOS
                Material(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.add_business, color: isDark ? Colors.white : Colors.black),
                    title: Text('Ofrecer Servicios', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SeleccionTipoServicioScreen()),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                  ),
                ),
                Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),

                // 5. ALIADOS DE MARGARITA
                Material(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.emoji_events, color: Colors.amber),
                    title: Text('⭐ Aliados de Margarita', style: TextStyle(color: Colors.amber)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PatrocinadoresScreen()),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                  ),
                ),

                // 6. MIS SERVICIOS
                Material(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.list_alt, color: isDark ? Colors.white : Colors.black),
                    title: Text('Mis Servicios', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MisServiciosScreen()),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                  ),
                ),
                Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),

                // 7. APÓYANOS
                Material(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.favorite, color: Colors.red),
                    title: Text('❤️ Apóyanos', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ApoyanosScreen()),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                  ),
                ),

                // ============================================
                // 8. 📤 COMPARTIR APP (NUEVO)
                // ============================================
                Material(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.share, color: isDark ? Colors.white : Colors.black),
                    title: Text('📤 Compartir App', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                      CompartirApp.compartir(context);
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                  ),
                ),

                Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),

                // 9. CONFIGURACIÓN
                Material(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.settings, color: isDark ? Colors.white : Colors.black),
                    title: Text('Configuración', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConfiguracionScreen()),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                  ),
                ),
                Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),

                // 10. CERRAR SESIÓN
                Material(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      Navigator.pop(context);
                      _cerrarSesion(context);
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.grey[600] : Colors.grey[400]),
                  ),
                ),
              ],
            ),
          ),

          // FOOTER
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? Colors.grey[900] : Colors.white,
            child: Text(
              'Versión 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _cerrarSesion(BuildContext context) {
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
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
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