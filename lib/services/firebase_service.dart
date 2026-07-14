import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ============================================
  // OBTENER SERVICIOS DESDE FIRESTORE
  // ============================================
  Stream<List<Map<String, dynamic>>> obtenerServicios() {
    return _firestore
        .collection('servicios')
        .where('estado', isEqualTo: 'activo')
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }

  // ============================================
  // OBTENER SERVICIOS POR CATEGORÍA
  // ============================================
  Stream<List<Map<String, dynamic>>> obtenerServiciosPorCategoria(String categoria) {
    return _firestore
        .collection('servicios')
        .where('tipo', isEqualTo: categoria)
        .where('estado', isEqualTo: 'activo')
        .orderBy('promedio', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }

  // ============================================
  // AGREGAR SERVICIO
  // ============================================
  Future<String?> agregarServicio(Map<String, dynamic> servicio) async {
    try {
      final docRef = await _firestore.collection('servicios').add({
        ...servicio,
        'fecha': FieldValue.serverTimestamp(),
        'estado': 'activo',
        'promedio': 0.0,
        'total_opiniones': 0,
        'distribucion': {'5': 0, '4': 0, '3': 0, '2': 0, '1': 0},
        'opiniones': [],
        'usuario_id': _auth.currentUser?.uid ?? 'anonimo',
      });
      return docRef.id;
    } catch (e) {
      print('❌ Error agregando servicio: $e');
      return null;
    }
  }

  // ============================================
  // AGREGAR VALORACIÓN
  // ============================================
  Future<void> agregarValoracion(String servicioId, Map<String, dynamic> valoracion) async {
    try {
      final docRef = _firestore.collection('servicios').doc(servicioId);
      
      final doc = await docRef.get();
      if (!doc.exists) return;
      
      final data = doc.data()!;
      List<dynamic> opiniones = data['opiniones'] ?? [];
      
      final usuarioId = valoracion['usuario_id'];
      final existingIndex = opiniones.indexWhere((op) => op['usuario_id'] == usuarioId);
      
      if (existingIndex != -1) {
        final puntuacionAnterior = opiniones[existingIndex]['puntuacion'];
        final distribucion = Map<String, dynamic>.from(data['distribucion'] ?? {});
        distribucion[puntuacionAnterior.toString()] = (distribucion[puntuacionAnterior.toString()] ?? 0) - 1;
        distribucion[valoracion['puntuacion'].toString()] = (distribucion[valoracion['puntuacion'].toString()] ?? 0) + 1;
        
        opiniones[existingIndex] = {
          ...valoracion,
          'fecha': FieldValue.serverTimestamp(),
        };
        
        final total = opiniones.length;
        final suma = opiniones.fold(0, (sum, op) => sum + (op['puntuacion'] as int));
        final promedio = double.parse((suma / total).toStringAsFixed(1));
        
        await docRef.update({
          'opiniones': opiniones,
          'distribucion': distribucion,
          'promedio': promedio,
          'total_opiniones': total,
        });
      } else {
        final distribucion = Map<String, dynamic>.from(data['distribucion'] ?? {});
        distribucion[valoracion['puntuacion'].toString()] = (distribucion[valoracion['puntuacion'].toString()] ?? 0) + 1;
        
        opiniones.add({
          ...valoracion,
          'fecha': FieldValue.serverTimestamp(),
        });
        
        final total = opiniones.length;
        final suma = opiniones.fold(0, (sum, op) => sum + (op['puntuacion'] as int));
        final promedio = double.parse((suma / total).toStringAsFixed(1));
        
        await docRef.update({
          'opiniones': opiniones,
          'distribucion': distribucion,
          'promedio': promedio,
          'total_opiniones': total,
        });
      }
    } catch (e) {
      print('❌ Error agregando valoración: $e');
    }
  }
}