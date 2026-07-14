import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ApoyanosScreen extends StatelessWidget {
  const ApoyanosScreen({super.key});

  void _copiarAlPortapapeles(BuildContext context, String texto) {
    Clipboard.setData(ClipboardData(text: texto));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Copiado al portapapeles'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _abrirUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('❤️ Apóyanos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================
            // MENSAJE DE APOYO
            // ============================================
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¡Apoya el desarrollo!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Si te gusta la app y quieres apoyar el desarrollo, '
                    'puedes hacerlo a través de los siguientes medios:',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ============================================
            // PAGO MÓVIL - BANCO DE VENEZUELA
            // ============================================
            _buildSeccion(
              context,
              icon: Icons.phone_android,
              titulo: '📱 Pago Móvil',
              color: Colors.green,
              descripcion: 'Transferencia desde el Banco de Venezuela',
              items: [
                {'label': 'Banco', 'valor': 'Banco de Venezuela'},
                {'label': 'Cédula', 'valor': '20325924'},
                {'label': 'Teléfono', 'valor': '04121119007'},
                {'label': 'Referencia', 'valor': 'Apoyo App'},
              ],
              onCopiar: _copiarAlPortapapeles,
              isDark: isDark,
            ),
            const SizedBox(height: 20),

            // ============================================
            // PAYPAL
            // ============================================
            _buildSeccion(
              context,
              icon: Icons.payments,
              titulo: '💰 PayPal',
              color: Colors.blue,
              descripcion: 'Envía desde cualquier parte del mundo',
              items: [
                {'label': 'Email', 'valor': 'raelymarin3@gmail.com'},
              ],
              onCopiar: _copiarAlPortapapeles,
              isDark: isDark,
              onPresionar: () => _abrirUrl('https://paypal.me/raelymarin3'),
            ),
            const SizedBox(height: 20),

            // ============================================
            // BINANCE
            // ============================================
            _buildSeccion(
              context,
              icon: Icons.currency_bitcoin,
              titulo: '₿ Binance',
              color: Colors.amber,
              descripcion: 'Criptomonedas (USDT, BTC, BNB, etc.)',
              items: [
                {'label': 'ID', 'valor': '920667762'},
                {'label': 'Usuario', 'valor': 'Raely marin'},
                {'label': 'Email', 'valor': 'raelymarin3@gmail.com'},
              ],
              onCopiar: _copiarAlPortapapeles,
              isDark: isDark,
            ),
            const SizedBox(height: 20),

            // ============================================
            // QR DE BINANCE
            // ============================================
            Center(
              child: Column(
                children: [
                  const Text(
                    '📷 Escanea el QR de Binance',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/qr_binance.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ============================================
            // MENSAJE DE AGRADECIMIENTO
            // ============================================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.favorite, color: Colors.red, size: 30),
                  const SizedBox(height: 8),
                  Text(
                    '¡Gracias por tu apoyo! ❤️',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cada contribución ayuda a mejorar la app y '
                    'seguir conectando a la gente de Margarita.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ============================================
            // VERSIÓN
            // ============================================
            Center(
              child: Text(
                'Versión 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccion(
    BuildContext context, {
    required IconData icon,
    required String titulo,
    required Color color,
    required String descripcion,
    required List<Map<String, String>> items,
    required Function(BuildContext, String) onCopiar,
    required bool isDark,
    VoidCallback? onPresionar,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const Spacer(),
                if (onPresionar != null)
                  GestureDetector(
                    onTap: onPresionar,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.open_in_new, size: 14, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(
                            'Abrir',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              descripcion,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),
            const SizedBox(height: 8),
            ...items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        '${item['label']}:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.grey[700],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item['valor']!,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onCopiar(context, item['valor']!),
                      child: Icon(
                        Icons.copy,
                        size: 18,
                        color: isDark ? Colors.grey[400] : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}