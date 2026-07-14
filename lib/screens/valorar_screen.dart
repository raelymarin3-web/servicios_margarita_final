import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../utils/profanity_filter.dart';

class ValorarScreen extends StatefulWidget {
  final Map<String, dynamic> profesional;
  final String categoria;

  const ValorarScreen({
    super.key,
    required this.profesional,
    required this.categoria,
  });

  @override
  State<ValorarScreen> createState() => _ValorarScreenState();
}

class _ValorarScreenState extends State<ValorarScreen> {
  int _puntuacion = 0;
  final TextEditingController _comentarioController = TextEditingController();
  bool _esEdicion = false;
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _verificarValoracionExistente();
  }

  void _verificarValoracionExistente() {
    final dataService = Provider.of<DataService>(context, listen: false);
    final usuarioId = 'usuario_001';
    final valoracionExistente = dataService.obtenerValoracionUsuario(
      widget.profesional['id'],
      usuarioId,
    );

    if (valoracionExistente != null) {
      setState(() {
        _esEdicion = true;
        _puntuacion = valoracionExistente['puntuacion'] ?? 0;
        _comentarioController.text = valoracionExistente['comentario'] ?? '';
      });
    }
  }

  void _enviarValoracion() async {
    if (_puntuacion == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Selecciona una puntuación'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final comentario = _comentarioController.text.trim();

    // 🔥 FILTRO DE MALAS PALABRAS
    if (comentario.isNotEmpty && ProfanityFilter.hasProfanity(comentario)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Tu comentario contiene lenguaje inapropiado. Por favor, edítalo.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      _enviando = true;
    });

    final valoracion = {
      'usuario': 'Usuario Actual',
      'usuario_id': 'usuario_001',
      'puntuacion': _puntuacion,
      'comentario': comentario,
      'fecha': DateTime.now().toString().substring(0, 10),
    };

    final dataService = Provider.of<DataService>(context, listen: false);
    
    // ✅ CORREGIDO: ahora es await y no devuelve bool
    await dataService.agregarValoracion(
      widget.profesional['id'],
      valoracion,
    );

    setState(() {
      _enviando = false;
    });

    // ✅ Siempre mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ ¡Gracias por tu valoración!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final nombre = widget.profesional['nombre'] ?? 'Profesional';
    final titulo = _esEdicion ? '✏️ Editar valoración' : '⭐ Calificar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: Text(
                nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 36, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              nombre,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _esEdicion 
                  ? 'Actualiza tu valoración'
                  : '¿Cómo fue tu experiencia?',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),

            // Estrellas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _puntuacion = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      index < _puntuacion ? Icons.star : Icons.star_border,
                      size: 50,
                      color: Colors.amber,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              _puntuacion > 0
                  ? '$_puntuacion de 5 estrellas'
                  : 'Toca una estrella para puntuar',
              style: TextStyle(
                fontSize: 14,
                color: _puntuacion > 0 
                    ? (isDark ? Colors.blue[300] : Colors.blue) 
                    : (isDark ? Colors.grey[500] : Colors.grey[500]),
                fontWeight: _puntuacion > 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 32),

            // Comentario
            TextField(
              controller: _comentarioController,
              maxLines: 4,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                labelText: _esEdicion 
                    ? 'Edita tu opinión (opcional)'
                    : 'Deja tu opinión (opcional)',
                hintText: '¿Qué tal fue el servicio?',
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                ),
                labelStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
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
                helperText: 'No uses lenguaje inapropiado',
                helperStyle: TextStyle(
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Indicador de filtro
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shield,
                  size: 14,
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                ),
                const SizedBox(width: 4),
                Text(
                  'Los comentarios con lenguaje inapropiado serán bloqueados',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Botones
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _enviando ? null : () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _enviando ? null : _enviarValoracion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: _enviando
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_esEdicion ? '📤 Actualizar' : '📤 Enviar'),
                  ),
                ),
              ],
            ),
            if (_esEdicion) ...[
              const SizedBox(height: 8),
              Text(
                'Ya calificaste a este profesional. Puedes editar tu valoración.',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}