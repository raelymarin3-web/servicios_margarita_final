import 'package:flutter/material.dart';
import '../models/patrocinador.dart';
import 'firebase_service.dart';

class DataService extends ChangeNotifier {
  // ============================================
  // 🔥 MODO FIREBASE
  // ============================================
  static const bool USAR_FIREBASE = true;

  List<Map<String, dynamic>> _servicios = [];
  List<Patrocinador> _patrocinadores = [];

  List<Map<String, dynamic>> get servicios => _servicios;
  List<Patrocinador> get patrocinadores => _patrocinadores;
  List<Patrocinador> get patrocinadoresDestacados => 
      _patrocinadores.where((p) => p.destacado).toList();

  final FirebaseService _firebase = FirebaseService();

  // ============================================
  // CONSTRUCTOR - ESCUCHA CAMBIOS EN FIRESTORE
  // ============================================
  DataService() {
    if (USAR_FIREBASE) {
      _escucharServicios();
    }
  }

  // ============================================
  // ESCUCHAR SERVICIOS EN TIEMPO REAL
  // ============================================
  void _escucharServicios() {
    _firebase.obtenerServicios().listen((servicios) {
      _servicios = servicios;
      notifyListeners();
      print('📡 ${_servicios.length} servicios cargados desde Firestore');
    });
  }

  // ============================================
  // OBTENER SERVICIO POR ID
  // ============================================
  Map<String, dynamic>? obtenerServicio(String id) {
    try {
      return _servicios.firstWhere((s) => s['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // AGREGAR SERVICIO
  // ============================================
  Future<void> agregarServicio(Map<String, dynamic> servicio) async {
    if (USAR_FIREBASE) {
      await _firebase.agregarServicio(servicio);
      print('📡 Servicio enviado a Firebase: ${servicio['nombre']}');
      return;
    }

    // MODO LOCAL (solo desarrollo)
    servicio['id'] = 'serv_${DateTime.now().millisecondsSinceEpoch}';
    servicio['fecha'] = DateTime.now().toString().substring(0, 10);
    servicio['estado'] = 'activo';
    servicio['promedio'] = 0.0;
    servicio['total_opiniones'] = 0;
    servicio['distribucion'] = {'5': 0, '4': 0, '3': 0, '2': 0, '1': 0};
    servicio['opiniones'] = [];
    if (servicio['redes'] == null) servicio['redes'] = {};
    if (servicio['fotos'] == null) servicio['fotos'] = [];
    if (servicio['descripcion'] == null) servicio['descripcion'] = '';
    if (servicio['usuario_id'] == null) servicio['usuario_id'] = 'usuario_001';
    if (servicio['municipio'] == null) servicio['municipio'] = '';
    if (servicio['localidad'] == null) servicio['localidad'] = '';
    
    _servicios.insert(0, servicio);
    notifyListeners();
  }

  void eliminarServicio(String id) {
    _servicios.removeWhere((s) => s['id'] == id);
    notifyListeners();
  }

  // ============================================
  // AGREGAR VALORACIÓN
  // ============================================
  Future<void> agregarValoracion(String servicioId, Map<String, dynamic> valoracion) async {
    if (USAR_FIREBASE) {
      await _firebase.agregarValoracion(servicioId, valoracion);
      print('📡 Valoración enviada a Firebase');
      return;
    }

    // MODO LOCAL
    final index = _servicios.indexWhere((s) => s['id'] == servicioId);
    if (index == -1) return;

    final servicio = _servicios[index];
    final usuarioId = valoracion['usuario_id'] ?? '';

    if (servicio['opiniones'] == null) {
      servicio['opiniones'] = [];
    }

    final existingIndex = servicio['opiniones'].indexWhere(
      (op) => op['usuario_id'] == usuarioId
    );

    if (existingIndex != -1) {
      final puntuacionAnterior = servicio['opiniones'][existingIndex]['puntuacion'];
      servicio['distribucion'][puntuacionAnterior.toString()] = 
          (servicio['distribucion'][puntuacionAnterior.toString()] ?? 0) - 1;

      servicio['opiniones'][existingIndex] = valoracion;

      final nuevaPuntuacion = valoracion['puntuacion'];
      servicio['distribucion'][nuevaPuntuacion.toString()] = 
          (servicio['distribucion'][nuevaPuntuacion.toString()] ?? 0) + 1;

      final total = servicio['total_opiniones'];
      final suma = servicio['opiniones'].fold(0, (sum, op) => sum + op['puntuacion']);
      servicio['promedio'] = double.parse((suma / total).toStringAsFixed(1));

      notifyListeners();
    } else {
      servicio['opiniones'].insert(0, valoracion);

      final puntuacion = valoracion['puntuacion'].toString();
      if (servicio['distribucion'] == null) {
        servicio['distribucion'] = {'5': 0, '4': 0, '3': 0, '2': 0, '1': 0};
      }
      servicio['distribucion'][puntuacion] =
          (servicio['distribucion'][puntuacion] ?? 0) + 1;

      servicio['total_opiniones'] = (servicio['total_opiniones'] ?? 0) + 1;

      final total = servicio['total_opiniones'];
      final suma = servicio['opiniones'].fold(0, (sum, op) => sum + op['puntuacion']);
      servicio['promedio'] = double.parse((suma / total).toStringAsFixed(1));

      notifyListeners();
    }
  }

  // ============================================
  // OBTENER VALORACIÓN DEL USUARIO
  // ============================================
  Map<String, dynamic>? obtenerValoracionUsuario(String servicioId, String usuarioId) {
    final servicio = obtenerServicio(servicioId);
    if (servicio == null) return null;

    final opiniones = servicio['opiniones'] ?? [];
    try {
      return opiniones.firstWhere((op) => op['usuario_id'] == usuarioId);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // OBTENER POR CATEGORÍA
  // ============================================
  List<Map<String, dynamic>> obtenerPorCategoria(String categoria) {
    final resultados = _servicios.where((s) => s['tipo'] == categoria).toList();
    return resultados;
  }

  List<Map<String, dynamic>> obtenerMisServicios(String usuarioId) {
    final resultados = _servicios.where((s) => s['usuario_id'] == usuarioId).toList();
    return resultados;
  }

  void limpiar() {
    _servicios.clear();
    _patrocinadores.clear();
    notifyListeners();
  }

  // ============================================
  // CARGAR DATOS DE EJEMPLO (SOLO DESARROLLO)
  // ============================================
  void cargarDatosEjemplo() {
    if (USAR_FIREBASE) {
      print('📡 MODO FIREBASE: Los datos vienen de Firestore');
      return;
    }
    // Si no hay datos y no estamos en Firebase, cargar desde JSON
  }

  void cargarPatrocinadores() {
    if (USAR_FIREBASE) {
      print('📡 MODO FIREBASE: Patrocinadores desde Firestore');
      return;
    }
  }
}