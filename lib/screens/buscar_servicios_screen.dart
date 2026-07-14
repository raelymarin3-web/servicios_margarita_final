import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../configuracion_provider.dart';
import 'profesionales_screen.dart';
import 'perfil_profesional_screen.dart';

class BuscarServiciosScreen extends StatefulWidget {
  const BuscarServiciosScreen({super.key});

  @override
  State<BuscarServiciosScreen> createState() => _BuscarServiciosScreenState();
}

class _BuscarServiciosScreenState extends State<BuscarServiciosScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _resultados = [];
  List<Map<String, dynamic>> _todosLosServicios = [];
  List<String> _categorias = [];
  bool _cargando = true;
  bool _mostrarResultados = false;
  String _municipioFiltro = 'Todos';

  final List<String> _municipios = [
    'Todos',
    'Antolín del Campo', 'Díaz', 'Arismendi', 'García', 'Gómez',
    'Península de Macanao', 'Maneiro', 'Marcano', 'Mariño', 'Tubores',
  ];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() {
    final dataService = Provider.of<DataService>(context, listen: false);
    
    final List<Map<String, dynamic>> servicios = [];
    for (var s in dataService.servicios) {
      if (s != null && s['tipo'] != null) {
        servicios.add(Map<String, dynamic>.from(s));
      }
    }
    
    _cargarCategoriasDesdeJson();
    
    setState(() {
      _todosLosServicios = servicios;
      _resultados = servicios;
      _cargando = false;
    });
  }

  void _cargarCategoriasDesdeJson() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/servicios.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final Map<String, dynamic> categoriasMap = jsonData['categorias'] as Map<String, dynamic>;
      setState(() {
        _categorias = categoriasMap.keys.toList();
      });
    } catch (e) {
      print('Error cargando categorías: $e');
      setState(() {
        _categorias = [];
      });
    }
  }

  void _aplicarFiltros() {
    final query = _searchController.text.toLowerCase().trim();
    final municipio = _municipioFiltro;

    var filtrados = List<Map<String, dynamic>>.from(_todosLosServicios);

    // ============================================
    // 🔥 FILTRAR POR MUNICIPIO (CORREGIDO)
    // ============================================
    if (municipio != 'Todos') {
      final municipioLower = municipio.toLowerCase().trim();
      filtrados = filtrados.where((s) {
        final mun = (s['municipio'] ?? '').toLowerCase().trim();
        return mun == municipioLower;
      }).toList();
    }

    // ============================================
    // FILTRAR POR BÚSQUEDA
    // ============================================
    if (query.isNotEmpty) {
      filtrados = filtrados.where((servicio) {
        final nombre = (servicio['nombre'] ?? '').toLowerCase();
        final tipo = (servicio['tipo'] ?? '').toLowerCase();
        final zona = (servicio['zona'] ?? '').toLowerCase();
        final localidad = (servicio['localidad'] ?? '').toLowerCase();
        final municipioServicio = (servicio['municipio'] ?? '').toLowerCase();
        return nombre.contains(query) ||
            tipo.contains(query) ||
            zona.contains(query) ||
            localidad.contains(query) ||
            municipioServicio.contains(query);
      }).toList();
    }

    // ============================================
    // ORDENAR POR REPUTACIÓN Y DESTACADOS
    // ============================================
    filtrados.sort((a, b) {
      final aDestacado = a['destacado'] ?? false;
      final bDestacado = b['destacado'] ?? false;
      if (aDestacado && !bDestacado) return -1;
      if (!aDestacado && bDestacado) return 1;

      final aPromedio = (a['promedio'] ?? 0.0).toDouble();
      final bPromedio = (b['promedio'] ?? 0.0).toDouble();
      return bPromedio.compareTo(aPromedio);
    });

    setState(() {
      _resultados = filtrados;
      _mostrarResultados = query.isNotEmpty || municipio != 'Todos';
    });
  }

  void _buscar(String query) {
    _aplicarFiltros();
  }

  void _limpiarBusqueda() {
    _searchController.clear();
    setState(() {
      _municipioFiltro = 'Todos';
      _mostrarResultados = false;
      _resultados = List<Map<String, dynamic>>.from(_todosLosServicios);
    });
    _aplicarFiltros();
    FocusScope.of(context).unfocus();
  }

  // ============================================
  // 🔥 FUNCIÓN PARA DEPURAR (VER QUÉ DATOS HAY)
  // ============================================
  void _depurarDatos() {
    print('📊 === DEPURACIÓN ===');
    print('📊 Total servicios: ${_todosLosServicios.length}');
    final municipios = _todosLosServicios.map((s) => s['municipio']).toSet().toList();
    print('📊 Municipios disponibles: $municipios');
    for (var s in _todosLosServicios) {
      print('   - ${s['nombre']} (${s['municipio']})');
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfiguracionProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Servicios'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ============================================
                // FILTRO POR MUNICIPIO
                // ============================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: DropdownButtonFormField<String>(
                    value: _municipioFiltro,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    dropdownColor: isDark ? Colors.grey[800] : Colors.white,
                    decoration: InputDecoration(
                      labelText: 'Filtrar por municipio',
                      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                      prefixIcon: const Icon(Icons.location_city, color: Colors.blue),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    items: _municipios.map((String municipio) {
                      return DropdownMenuItem<String>(
                        value: municipio,
                        child: Text(municipio, style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _municipioFiltro = value!;
                        _aplicarFiltros();
                      });
                    },
                  ),
                ),

                // ============================================
                // BARRA DE BÚSQUEDA
                // ============================================
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _buscar,
                    autofocus: true,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: '🔎 Buscar por nombre, categoría, municipio o localidad...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[500],
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.blue),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[400]),
                              onPressed: _limpiarBusqueda,
                            )
                          : null,
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                ),

                // ============================================
                // CONTENIDO
                // ============================================
                Expanded(
                  child: _mostrarResultados
                      ? _buildResultadosList(config)
                      : _buildGridCategorias(isDark),
                ),
              ],
            ),
    );
  }

  // ============================================
  // GRID DE CATEGORÍAS
  // ============================================
  Widget _buildGridCategorias(bool isDark) {
    if (_categorias.isEmpty) {
      return const Center(child: Text('No hay categorías disponibles'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _categorias.length,
      itemBuilder: (context, index) {
        final categoria = _categorias[index];
        return _buildCategoryCard(categoria, isDark);
      },
    );
  }

  Widget _buildCategoryCard(String categoria, bool isDark) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfesionalesScreen(
                categoria: categoria,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconForCategory(categoria),
                size: 30,
                color: Colors.blue,
              ),
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
      case 'Albañilería':
        return Icons.construction;
      case 'Transporte':
        return Icons.directions_car;
      case 'Delivery':
        return Icons.delivery_dining;
      case 'Electricidad':
        return Icons.bolt;
      case 'Plomería':
        return Icons.plumbing;
      case 'Jardinería':
        return Icons.grass;
      case 'Mecánicos':
        return Icons.settings;
      case 'Comercios':
        return Icons.store;
      case 'Servicios Varios':
        return Icons.work;
      default:
        return Icons.category;
    }
  }

  // ============================================
  // RESULTADOS DE BÚSQUEDA
  // ============================================
  Widget _buildResultadosList(ConfiguracionProvider config) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _resultados.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No se encontraron servicios',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Intenta con otro filtro o palabra',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _resultados.length,
            itemBuilder: (context, index) {
              final servicio = _resultados[index];
              return _buildResultCard(servicio, config);
            },
          );
  }

  Widget _buildResultCard(
    Map<String, dynamic> servicio,
    ConfiguracionProvider config,
  ) {
    final nombre = servicio['nombre'] ?? 'Sin nombre';
    final telefono = servicio['telefono'] ?? '';
    final zona = servicio['zona'] ?? '';
    final municipio = servicio['municipio'] ?? '';
    final localidad = servicio['localidad'] ?? '';
    final tipo = servicio['tipo'] ?? '';
    final promedio = (servicio['promedio'] ?? 0.0).toDouble();
    final totalOpiniones = servicio['total_opiniones'] ?? 0;
    final destacado = servicio['destacado'] ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bool mostrarTelefono = config.mostrarTelefono && telefono.isNotEmpty;

    return Card(
      elevation: destacado ? 4 : 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: destacado
            ? BorderSide(color: Colors.amber[700]!, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PerfilProfesionalScreen(
                profesional: servicio,
                categoria: tipo,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (destacado)
                          Icon(Icons.star, color: Colors.amber[700], size: 16),
                        if (destacado) const SizedBox(width: 4),
                        Text(
                          nombre,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tipo,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (zona.isNotEmpty)
                      Text(
                        '📍 $zona',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    if (municipio.isNotEmpty)
                      Text(
                        '🏛️ $municipio',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    if (localidad.isNotEmpty)
                      Text(
                        '📍 $localidad',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    if (promedio > 0)
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
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    if (mostrarTelefono)
                      Text(
                        '📞 $telefono',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
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
          (index) => const Icon(Icons.star, color: Colors.amber, size: 14),
        ),
        if (hasHalf)
          const Icon(Icons.star_half, color: Colors.amber, size: 14),
        ...List.generate(
          5 - fullStars - (hasHalf ? 1 : 0),
          (index) => const Icon(Icons.star_border, color: Colors.amber, size: 14),
        ),
      ],
    );
  }
}