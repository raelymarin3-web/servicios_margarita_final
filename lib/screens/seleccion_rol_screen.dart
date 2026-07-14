import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'seleccion_tipo_servicio_screen.dart';

class SeleccionRolScreen extends StatelessWidget {
  final String nombre;

  const SeleccionRolScreen({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emoji_emotions, size: 50, color: Colors.blue),
              ),
              const SizedBox(height: 24),
              Text(
                '¡Bienvenido, $nombre!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 8),
              const Text('¿Cómo quieres usar la app?', style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 40),

              // Buscar Servicios
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.search, size: 30, color: Colors.blue),
                  ),
                  title: const Text('🔍 Buscar Servicios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Encuentra profesionales y negocios en Margarita', style: TextStyle(color: Colors.grey)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Ofrecer Servicios
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.add_business, size: 30, color: Colors.green),
                  ),
                  title: const Text('🏪 Ofrecer Servicios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Registra tu negocio, taxi o profesión', style: TextStyle(color: Colors.grey)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SeleccionTipoServicioScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text('⏭️ Ir al inicio (puedes cambiar después)', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}