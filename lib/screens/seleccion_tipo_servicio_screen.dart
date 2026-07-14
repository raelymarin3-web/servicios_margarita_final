import 'package:flutter/material.dart';
import 'formulario_taxi_screen.dart';
import 'formulario_servicio_vario_screen.dart';
import 'registro_negocio_screen.dart';
import 'formulario_delivery_screen.dart';

class SeleccionTipoServicioScreen extends StatelessWidget {
  const SeleccionTipoServicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Qué ofreces?'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
          children: [
            _buildOptionCard(
              context,
              icon: Icons.store,
              label: 'Negocio/Bodega',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistroNegocioScreen()),
                );
              },
            ),
            _buildOptionCard(
              context,
              icon: Icons.taxi_alert,
              label: 'Taxi',
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormularioTaxiScreen(tipo: 'taxi'),
                  ),
                );
              },
            ),
            _buildOptionCard(
              context,
              icon: Icons.two_wheeler,
              label: 'Moto Taxi',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormularioTaxiScreen(tipo: 'moto_taxi'),
                  ),
                );
              },
            ),
            _buildOptionCard(
              context,
              icon: Icons.delivery_dining,
              label: 'Delivery',
              color: Colors.orange.shade300,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormularioDeliveryScreen(),
                  ),
                );
              },
            ),
            _buildOptionCard(
              context,
              icon: Icons.construction,
              label: 'Servicio Varios',
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormularioServicioVarioScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}