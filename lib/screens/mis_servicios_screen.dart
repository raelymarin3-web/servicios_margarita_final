import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';

class MisServiciosScreen extends StatefulWidget {
  const MisServiciosScreen({super.key});

  @override
  State<MisServiciosScreen> createState() => _MisServiciosScreenState();
}

class _MisServiciosScreenState extends State<MisServiciosScreen> {
  final String _usuarioId = 'usuario_001';

  @override
  Widget build(BuildContext context) {
    final dataService = context.watch<DataService>();
    
    // OBTENER SOLO SERVICIOS DEL USUARIO
    final misServicios = dataService.obtenerMisServicios(_usuarioId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Mis Servicios'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/seleccion_tipo');
            },
          ),
        ],
      ),
      body: misServicios.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: misServicios.length,
              itemBuilder: (context, index) {
                final servicio = misServicios[index];
                return _buildServiceCard(servicio, dataService);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business_center, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No tienes servicios registrados',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón + para agregar uno',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> servicio, DataService dataService) {
    final String tipo = servicio['tipo'] ?? 'servicio';
    final String nombre = servicio['nombre'] ?? 'Sin nombre';
    final String telefono = servicio['telefono'] ?? '';
    final String zona = servicio['zona'] ?? '';
    final String municipio = servicio['municipio'] ?? '';
    final String localidad = servicio['localidad'] ?? '';
    final String estado = servicio['estado'] ?? 'activo';
    final double promedio = (servicio['promedio'] ?? 0).toDouble();
    final int totalOpiniones = servicio['total_opiniones'] ?? 0;

    IconData icono;
    Color color;

    switch (tipo) {
      case 'taxi':
        icono = Icons.taxi_alert;
        color = Colors.orange;
        break;
      case 'moto_taxi':
        icono = Icons.two_wheeler;
        color = Colors.green;
        break;
      case 'negocio':
        icono = Icons.store;
        color = Colors.blue;
        break;
      case 'delivery':
        icono = Icons.delivery_dining;
        color = Colors.orange.shade300;
        break;
      default:
        icono = Icons.work;
        color = Colors.purple;
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icono, color: color, size: 30),
        ),
        title: Text(
          nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (telefono.isNotEmpty) Text('📞 $telefono'),
            if (zona.isNotEmpty) Text('📍 $zona', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            if (municipio.isNotEmpty) 
              Text('🏛️ $municipio', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            if (localidad.isNotEmpty) 
              Text('📍 $localidad', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            if (promedio > 0)
              Row(
                children: [
                  _buildStarDisplay(promedio),
                  const SizedBox(width: 4),
                  Text('$promedio', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(' ($totalOpiniones)', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: estado == 'activo' ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(estado, style: TextStyle(color: estado == 'activo' ? Colors.green : Colors.red, fontSize: 12, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(width: 8),
                Text(servicio['fecha'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✏️ Editar (Próximamente)'), duration: Duration(seconds: 2)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                dataService.eliminarServicio(servicio['id']);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Servicio eliminado'), backgroundColor: Colors.green),
                );
              },
            ),
          ],
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('👁️ Ver detalle de: $nombre'), duration: const Duration(seconds: 2)),
          );
        },
      ),
    );
  }

  Widget _buildStarDisplay(double promedio) {
    final fullStars = promedio.floor();
    final hasHalf = promedio - fullStars >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(fullStars, (index) => const Icon(Icons.star, color: Colors.amber, size: 12)),
        if (hasHalf) const Icon(Icons.star_half, color: Colors.amber, size: 12),
        ...List.generate(5 - fullStars - (hasHalf ? 1 : 0), (index) => const Icon(Icons.star_border, color: Colors.amber, size: 12)),
      ],
    );
  }
}