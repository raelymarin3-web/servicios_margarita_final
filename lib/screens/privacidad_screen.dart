import 'package:flutter/material.dart';

class PrivacidadScreen extends StatelessWidget {
  const PrivacidadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidad'),
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
            _buildSection(
              '1. Datos que recogemos',
              'Para ofrecerte nuestros servicios, recopilamos la siguiente información:\n\n'
              '• Nombre y apellido\n'
              '• Correo electrónico\n'
              '• Número de teléfono\n'
              '• Ubicación (si decides compartirla voluntariamente)\n'
              '• Fotos de perfil y documentos (cuando sea necesario para verificación)\n'
              '• Datos de uso y preferencias dentro de la aplicación',
              isDark,
            ),
            _buildSection(
              '2. Cómo usamos tus datos',
              'Utilizamos tu información para:\n\n'
              '• Crear y mantener tu cuenta\n'
              '• Mostrar tus servicios en el directorio de la app\n'
              '• Comunicarnos contigo sobre novedades y actualizaciones\n'
              '• Mejorar la experiencia de usuario y la calidad del servicio\n'
              '• Gestionar los pagos de servicios premium (si aplica)',
              isDark,
            ),
            _buildSection(
              '3. Compartición de datos',
              '• No vendemos, alquilamos ni compartimos tus datos personales con terceros.\n\n'
              '• Tu información de contacto (teléfono, ubicación) será visible para otros usuarios que busquen tus servicios, ya que la app funciona como un directorio público.\n\n'
              '• Podremos compartir datos únicamente cuando sea requerido por ley o para proteger nuestros derechos legales.',
              isDark,
            ),
            _buildSection(
              '4. Seguridad',
              'Implementamos medidas técnicas y organizativas para proteger tus datos personales:\n\n'
              '• Almacenamiento seguro en Firebase con encriptación estándar\n'
              '• Acceso restringido a los datos\n'
              '• Actualizaciones periódicas de seguridad\n\n'
              'Sin embargo, ninguna medida es 100% segura. Al usar la app, aceptas este riesgo.',
              isDark,
            ),
            _buildSection(
              '5. Derechos del usuario',
              'Tienes derecho a:\n\n'
              '• Acceder a tus datos personales en cualquier momento\n'
              '• Solicitar la corrección de datos incorrectos\n'
              '• Solicitar la eliminación de tu cuenta y todos tus datos\n'
              '• Oponerte al uso de tus datos para fines específicos\n\n'
              'Para ejercer estos derechos, contáctanos a través del correo de soporte.',
              isDark,
            ),
            _buildSection(
              '6. Retención de datos',
              'Mantendremos tus datos mientras tu cuenta esté activa. Al cerrar tu cuenta, eliminaremos toda tu información personal de nuestros sistemas en un plazo razonable.',
              isDark,
            ),
            _buildSection(
              '7. Cookies y tecnologías similares',
              'No utilizamos cookies en esta aplicación, pero el servicio de Firebase puede usar tecnologías similares para el funcionamiento correcto de la autenticación y la base de datos.',
              isDark,
            ),
            _buildSection(
              '8. Privacidad de menores',
              'La aplicación no está dirigida a menores de 18 años. No recopilamos conscientemente datos de menores. Si descubrimos que un menor ha proporcionado información, eliminaremos esos datos.',
              isDark,
            ),
            _buildSection(
              '9. Cambios a esta política',
              'Podemos actualizar esta política de privacidad ocasionalmente. Los cambios serán notificados en la aplicación y entrarán en vigor al momento de su publicación.',
              isDark,
            ),
            _buildSection(
              '10. Contacto',
              'Si tienes preguntas sobre esta política de privacidad, contáctanos:\n\n'
              '📧 privacidad@serviciosmargarita.com\n'
              '📱 +58 412-XXXXXXX',
              isDark,
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Última actualización: 15 de enero de 2025',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}