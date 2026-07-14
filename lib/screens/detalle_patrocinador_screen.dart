import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/patrocinador.dart';

class DetallePatrocinadorScreen extends StatelessWidget {
  final Patrocinador patrocinador;

  const DetallePatrocinadorScreen({super.key, required this.patrocinador});

  void _abrirUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _abrirGoogleMaps(String direccion) async {
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(direccion)}'
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(patrocinador.nombre),
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
            // Logo
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(Icons.business, size: 60, color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nombre
            Center(
              child: Text(
                patrocinador.nombre,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Destacado
            if (patrocinador.destacado)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '⭐ Destacado',
                    style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            const SizedBox(height: 8),

            // Calificación
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  Text(
                    ' ${patrocinador.calificacion}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' (${patrocinador.totalOpiniones} opiniones)',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Descripción
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                patrocinador.descripcion,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Información
            _buildInfoRow(Icons.location_on, 'Dirección', patrocinador.direccion, isDark),
            _buildInfoRow(Icons.phone, 'Teléfono', patrocinador.telefono, isDark),
            _buildInfoRow(Icons.access_time, 'Horario', patrocinador.horario, isDark),
            if (patrocinador.web.isNotEmpty)
              _buildInfoRow(Icons.language, 'Web', patrocinador.web, isDark),

            const SizedBox(height: 16),

            // ============================================
            // MAPA PLACEHOLDER
            // ============================================
            if (patrocinador.direccion.isNotEmpty) ...[
              const Text(
                '📍 Ubicación',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                patrocinador.direccion,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _abrirGoogleMaps(patrocinador.direccion),
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

            // Redes Sociales
            if (patrocinador.redesSociales.isNotEmpty) ...[
              const Text(
                '🌐 Redes Sociales',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: patrocinador.redesSociales.map((url) {
                  return _buildRedSocialButton(url, isDark);
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Ofertas
            if (patrocinador.ofertas.isNotEmpty) ...[
              const Text(
                '🔥 Ofertas Especiales',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...patrocinador.ofertas.map((oferta) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          oferta,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _abrirUrl('tel:${patrocinador.telefono}');
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('Llamar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _abrirUrl('https://wa.me/${patrocinador.whatsapp}');
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedSocialButton(String url, bool isDark) {
    return GestureDetector(
      onTap: () => _abrirUrl(url),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.open_in_new,
              size: 14,
              color: isDark ? Colors.blue[300] : Colors.blue,
            ),
            const SizedBox(width: 4),
            Text(
              _getRedSocialName(url),
              style: TextStyle(
                color: isDark ? Colors.blue[300] : Colors.blue,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRedSocialName(String url) {
    if (url.contains('instagram')) return 'Instagram';
    if (url.contains('facebook')) return 'Facebook';
    if (url.contains('twitter')) return 'Twitter';
    if (url.contains('youtube')) return 'YouTube';
    if (url.contains('tiktok')) return 'TikTok';
    return 'Red Social';
  }
}