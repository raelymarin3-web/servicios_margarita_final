import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import 'valorar_screen.dart';

class PerfilProfesionalScreen extends StatefulWidget {
  final Map<String, dynamic> profesional;
  final String categoria;

  const PerfilProfesionalScreen({
    super.key,
    required this.profesional,
    required this.categoria,
  });

  @override
  State<PerfilProfesionalScreen> createState() => _PerfilProfesionalScreenState();
}

class _PerfilProfesionalScreenState extends State<PerfilProfesionalScreen> {
  late Map<String, dynamic> _profesional;

  @override
  void initState() {
    super.initState();
    _profesional = Map<String, dynamic>.from(widget.profesional);
    _actualizarDesdeDataService();
  }

  void _actualizarDesdeDataService() {
    final dataService = Provider.of<DataService>(context, listen: false);
    final servicioId = widget.profesional['id'];
    if (servicioId != null) {
      final actualizado = dataService.obtenerServicio(servicioId);
      if (actualizado != null) {
        setState(() {
          _profesional = actualizado;
        });
      }
    }
  }

  bool _usuarioYaCalifico() {
    final dataService = Provider.of<DataService>(context, listen: false);
    final usuarioId = 'usuario_001';
    final valoracion = dataService.obtenerValoracionUsuario(
      widget.profesional['id'],
      usuarioId,
    );
    return valoracion != null;
  }

  void _abrirGoogleMaps(String direccion) async {
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(direccion)}'
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _abrirUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataService = context.watch<DataService>();

    final servicioId = widget.profesional['id'];
    if (servicioId != null) {
      final actualizado = dataService.obtenerServicio(servicioId);
      if (actualizado != null) {
        _profesional = actualizado;
      }
    }

    final nombre = _profesional['nombre'] ?? 'Sin nombre';
    final telefono = _profesional['telefono'] ?? '';
    final zona = _profesional['zona'] ?? '';
    final municipio = _profesional['municipio'] ?? '';
    final localidad = _profesional['localidad'] ?? '';
    final direccion = _profesional['direccion'] ?? zona;
    final promedio = (_profesional['promedio'] ?? 0.0).toDouble();
    final totalOpiniones = _profesional['total_opiniones'] ?? 0;
    final descripcion = _profesional['descripcion'] ?? '';
    final fotos = _profesional['fotos'] ?? [];
    final redes = _profesional['redes'] ?? {};
    final tipo = _profesional['tipo'] ?? widget.categoria;
    final opiniones = _profesional['opiniones'] ?? [];
    final distribucion = _profesional['distribucion'] ?? {};
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final yaCalifico = _usuarioYaCalifico();

    return Scaffold(
      appBar: AppBar(
        title: Text(nombre),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================
            // FOTO DE PERFIL
            // ============================================
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue,
                child: Text(
                  nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ============================================
            // NOMBRE
            // ============================================
            Center(
              child: Text(
                nombre,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 4),

            // ============================================
            // TIPO DE SERVICIO
            // ============================================
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tipo,
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ============================================
            // ESTRELLAS
            // ============================================
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStarDisplay(promedio),
                  const SizedBox(width: 8),
                  Text(
                    '$promedio',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' ($totalOpiniones opiniones)',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ============================================
            // MUNICIPIO Y LOCALIDAD
            // ============================================
            if (municipio.isNotEmpty || zona.isNotEmpty)
              Center(
                child: Column(
                  children: [
                    if (municipio.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_city, color: Colors.blue, size: 18),
                            const SizedBox(width: 8),
                            Text(municipio),
                          ],
                        ),
                      ),
                    if (localidad.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.home, color: Colors.blue, size: 18),
                            const SizedBox(width: 8),
                            Text(localidad),
                          ],
                        ),
                      ),
                    if (zona.isNotEmpty && municipio.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on, color: Colors.blue, size: 18),
                            const SizedBox(width: 8),
                            Text(zona),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // ============================================
            // DESCRIPCIÓN
            // ============================================
            if (descripcion.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  descripcion,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[700],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // ============================================
            // MAPA PLACEHOLDER
            // ============================================
            if (direccion.isNotEmpty) ...[
              const Text(
                '📍 Ubicación',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                direccion,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _abrirGoogleMaps(direccion),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map,
                        size: 40,
                        color: isDark ? Colors.blue[300] : Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toca para ver en Google Maps',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.blue[300] : Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '📍 Ver ubicación exacta',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ============================================
            // DISTRIBUCIÓN DE OPINIONES
            // ============================================
            if (totalOpiniones > 0) ...[
              const Text(
                '📊 Distribución de opiniones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildDistributionBar(distribucion, totalOpiniones, isDark),
              const SizedBox(height: 16),
            ],

            // ============================================
            // FOTOS DE PRODUCTOS
            // ============================================
            if (fotos.isNotEmpty) ...[
              const Text(
                '📸 Fotos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: fotos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.image, color: Colors.grey, size: 40),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ============================================
            // REDES SOCIALES
            // ============================================
            const Text(
              '🌐 Redes Sociales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (redes['instagram'] != null && redes['instagram'].isNotEmpty)
                  _buildRedSocial(
                    icon: Icons.camera_alt,
                    color: Colors.pink,
                    label: 'Instagram',
                    url: redes['instagram'],
                  ),
                if (redes['facebook'] != null && redes['facebook'].isNotEmpty)
                  _buildRedSocial(
                    icon: Icons.facebook,
                    color: Colors.blue,
                    label: 'Facebook',
                    url: redes['facebook'],
                  ),
                if (redes['twitter'] != null && redes['twitter'].isNotEmpty)
                  _buildRedSocial(
                    icon: Icons.alternate_email,
                    color: Colors.black,
                    label: 'Twitter/X',
                    url: redes['twitter'],
                  ),
                if (redes['whatsapp'] != null && redes['whatsapp'].isNotEmpty)
                  _buildRedSocial(
                    icon: Icons.chat,
                    color: Colors.green,
                    label: 'WhatsApp',
                    url: redes['whatsapp'],
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // ============================================
            // ÚLTIMAS OPINIONES
            // ============================================
            const Text(
              '📝 Últimas opiniones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (opiniones.isEmpty)
              Text(
                'Aún no hay opiniones. ¡Sé el primero en calificar!',
                style: TextStyle(color: Colors.grey[500]),
              )
            else ...[
              ...opiniones.take(3).map((op) => _buildOpinionCard(op, isDark)),
              if (opiniones.length > 3)
                TextButton(
                  onPressed: () {},
                  child: const Text('Ver todas las opiniones'),
                ),
            ],
            const SizedBox(height: 16),

            // ============================================
            // BOTÓN CALIFICAR / EDITAR
            // ============================================
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ValorarScreen(
                        profesional: _profesional,
                        categoria: widget.categoria,
                      ),
                    ),
                  );
                  if (result == true) {
                    _actualizarDesdeDataService();
                    setState(() {});
                  }
                },
                icon: const Icon(Icons.star),
                label: Text(
                  yaCalifico ? '✏️ Editar mi valoración' : '⭐ Calificar este profesional',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: yaCalifico ? Colors.orange : Colors.amber,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ============================================
            // BOTONES DE ACCIÓN (LLAMAR, WHATSAPP)
            // ============================================
            if (telefono.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _abrirUrl('tel:$telefono');
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('📞 Llamar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _abrirUrl('https://wa.me/$telefono');
                      },
                      icon: const Icon(Icons.chat),
                      label: const Text('💬 WhatsApp'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ============================================
  // WIDGETS
  // ============================================

  Widget _buildStarDisplay(double promedio) {
    final fullStars = promedio.floor();
    final hasHalf = promedio - fullStars >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          fullStars,
          (index) => const Icon(Icons.star, color: Colors.amber, size: 18),
        ),
        if (hasHalf)
          const Icon(Icons.star_half, color: Colors.amber, size: 18),
        ...List.generate(
          5 - fullStars - (hasHalf ? 1 : 0),
          (index) => const Icon(Icons.star_border, color: Colors.amber, size: 18),
        ),
      ],
    );
  }

  Widget _buildDistributionBar(Map<String, dynamic> distribucion, int total, bool isDark) {
    final order = ['5', '4', '3', '2', '1'];

    return Column(
      children: order.map((key) {
        final count = distribucion[key] ?? 0;
        final porcentaje = total > 0 ? (count / total * 100) : 0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  '$key ★',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: porcentaje / 100,
                    minHeight: 12,
                    backgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getColorForStars(int.parse(key)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  '${porcentaje.toInt()}%',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getColorForStars(int stars) {
    switch (stars) {
      case 5:
        return Colors.green;
      case 4:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 2:
        return Colors.deepOrange;
      case 1:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildOpinionCard(Map<String, dynamic> opinion, bool isDark) {
    final puntuacion = (opinion['puntuacion'] ?? 0) as int;
    final estrellas = '★' * puntuacion + '☆' * (5 - puntuacion);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  estrellas,
                  style: const TextStyle(color: Colors.amber),
                ),
                const SizedBox(width: 8),
                Text(
                  opinion['usuario'] ?? 'Anónimo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const Spacer(),
                Text(
                  opinion['fecha'] ?? '',
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (opinion['comentario'] != null && opinion['comentario'].isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  opinion['comentario'],
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[700],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRedSocial({
    required IconData icon,
    required Color color,
    required String label,
    required String url,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _abrirUrl(url),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            Icon(
              Icons.open_in_new,
              size: 14,
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}