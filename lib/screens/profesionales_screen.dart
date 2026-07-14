import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../configuracion_provider.dart';
import '../services/data_service.dart';
import 'perfil_profesional_screen.dart';

class ProfesionalesScreen extends StatefulWidget {
  final String categoria;

  const ProfesionalesScreen({super.key, required this.categoria});

  @override
  State<ProfesionalesScreen> createState() => _ProfesionalesScreenState();
}

class _ProfesionalesScreenState extends State<ProfesionalesScreen> {
  List<Map<String, dynamic>> profesionales = [];
  bool cargando = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    cargarProfesionales();
  }

  void cargarProfesionales() {
    try {
      final dataService = Provider.of<DataService>(context, listen: false);
      final resultados = dataService.obtenerPorCategoria(widget.categoria);
      
      final listaConvertida = <Map<String, dynamic>>[];
      for (var item in resultados) {
        if (item is Map) {
          listaConvertida.add(Map<String, dynamic>.from(item));
        }
      }
      
      setState(() {
        profesionales = listaConvertida;
        cargando = false;
      });
      
      print('✅ Categoría: ${widget.categoria}, Profesionales: ${listaConvertida.length}');
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        cargando = false;
      });
      print('❌ Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfiguracionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoria),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : profesionales.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_off, size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No hay profesionales en esta categoría',
                            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: profesionales.length,
                      itemBuilder: (context, index) {
                        final profesional = profesionales[index];
                        return _buildProfessionalCard(profesional, config);
                      },
                    ),
    );
  }

  Widget _buildProfessionalCard(Map<String, dynamic> profesional, ConfiguracionProvider config) {
    final nombre = profesional['nombre'] ?? 'Sin nombre';
    final telefono = profesional['telefono'] ?? '';
    final zona = profesional['zona'] ?? '';
    final municipio = profesional['municipio'] ?? '';
    final localidad = profesional['localidad'] ?? '';
    final promedio = (profesional['promedio'] ?? 0.0).toDouble();
    final totalOpiniones = profesional['total_opiniones'] ?? 0;

    final bool mostrarTelefono = config.mostrarTelefono && telefono.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (zona.isNotEmpty) Text('📍 $zona', style: const TextStyle(fontSize: 12)),
            if (municipio.isNotEmpty) Text('🏛️ $municipio', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            if (localidad.isNotEmpty) Text('📍 $localidad', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            if (mostrarTelefono) Text('📞 $telefono'),
            if (!config.mostrarTelefono && telefono.isNotEmpty)
              const Text('🔒 Teléfono oculto', style: TextStyle(color: Colors.grey, fontSize: 12)),
            if (promedio > 0) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildStarDisplay(promedio),
                  const SizedBox(width: 8),
                  Text(
                    '$promedio',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' ($totalOpiniones opiniones)',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: mostrarTelefono
            ? IconButton(
                icon: const Icon(Icons.phone, color: Colors.green),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Llamando a $telefono...'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              )
            : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PerfilProfesionalScreen(
                profesional: profesional,
                categoria: widget.categoria,
              ),
            ),
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
        ...List.generate(
          fullStars,
          (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
        ),
        if (hasHalf)
          const Icon(Icons.star_half, color: Colors.amber, size: 16),
        ...List.generate(
          5 - fullStars - (hasHalf ? 1 : 0),
          (index) => const Icon(Icons.star_border, color: Colors.amber, size: 16),
        ),
      ],
    );
  }
}