import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import '../configuracion_provider.dart';
import 'profesionales_screen.dart';

class ServiciosScreen extends StatefulWidget {
  const ServiciosScreen({super.key});

  @override
  State<ServiciosScreen> createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {
  List<String> categorias = [];
  bool cargando = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/servicios.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      final Map<String, dynamic> categoriasMap = data['categorias'] as Map<String, dynamic>;
      
      setState(() {
        categorias = categoriasMap.keys.toList();
        cargando = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error al cargar datos: $e';
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfiguracionProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
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
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(error, textAlign: TextAlign.center),
                    ],
                  ),
                )
              : categorias.isEmpty
                  ? const Center(child: Text('No hay categorías disponibles'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.6,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: categorias.length,
                      itemBuilder: (context, index) {
                        final categoria = categorias[index];
                        return _buildCategoryCard(categoria);
                      },
                    ),
    );
  }

  Widget _buildCategoryCard(String categoria) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          final config = Provider.of<ConfiguracionProvider>(context, listen: false);
          if (!config.notificaciones) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Las notificaciones están desactivadas'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfesionalesScreen(categoria: categoria),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_getIconForCategory(categoria), size: 30, color: Colors.blue),
              const SizedBox(height: 4),
              Text(
                categoria,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForCategory(String categoria) {
    switch (categoria) {
      case 'Albañilería': return Icons.construction;
      case 'Transporte': return Icons.directions_car;
      case 'Delivery': return Icons.delivery_dining;
      case 'Electricidad': return Icons.bolt;
      case 'Plomería': return Icons.plumbing;
      case 'Jardinería': return Icons.grass;
      case 'Mecánicos': return Icons.settings;
      case 'Comercios': return Icons.store;
      case 'Servicios Varios': return Icons.work;
      default: return Icons.category;
    }
  }
}