import 'package:flutter/material.dart';

class TerminosScreen extends StatelessWidget {
  const TerminosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
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
              '1. Aceptación de los términos',
              'Al registrarte en "Servicios Margarita", aceptas estos términos y condiciones. Si no estás de acuerdo, no debes usar la aplicación.',
              isDark,
            ),
            _buildSection(
              '2. Descripción del servicio',
              '"Servicios Margarita" es una aplicación móvil que conecta a usuarios con profesionales y negocios en la isla de Margarita, Venezuela. La app funciona como un directorio de servicios, permitiendo a los usuarios encontrar y contactar a prestadores de servicios locales.',
              isDark,
            ),
            _buildSection(
              '3. Registro y cuenta',
              '• Debes proporcionar información veraz, completa y actualizada.\n'
              '• Eres el único responsable de mantener la confidencialidad de tu cuenta y contraseña.\n'
              '• No puedes compartir tu cuenta con terceros.\n'
              '• Nos reservamos el derecho de suspender cuentas que no cumplan con estos términos.',
              isDark,
            ),
            _buildSection(
              '4. Contenido del usuario',
              '• Los servicios, publicaciones y contenido que publicas son tu responsabilidad.\n'
              '• No puedes publicar contenido ilegal, ofensivo, difamatorio o engañoso.\n'
              '• Nos reservamos el derecho de eliminar cualquier contenido que consideremos inapropiado.\n'
              '• Los datos de contacto (teléfonos, direcciones) deben ser verídicos.',
              isDark,
            ),
            _buildSection(
              '5. Conducta prohibida',
              'No está permitido:\n'
              '• Publicar información falsa o engañosa.\n'
              '• Enviar spam o publicidad no autorizada.\n'
              '• Acosar, intimidar o discriminar a otros usuarios.\n'
              '• Usar la aplicación para actividades ilegales.\n'
              '• Intentar acceder a cuentas de otros usuarios.',
              isDark,
            ),
            _buildSection(
              '6. Propiedad intelectual',
              '• La aplicación, su diseño, logotipo y contenido son propiedad del desarrollador.\n'
              '• No puedes copiar, modificar, distribuir o vender la aplicación sin autorización expresa.\n'
              '• Los nombres y logos de negocios son propiedad de sus respectivos dueños.',
              isDark,
            ),
            _buildSection(
              '7. Limitación de responsabilidad',
              '• La aplicación se proporciona "tal cual" y "según disponibilidad".\n'
              '• No nos hacemos responsables por daños directos, indirectos o incidentales.\n'
              '• Los servicios contratados a través de la app son responsabilidad exclusiva del prestador.\n'
              '• No garantizamos la disponibilidad continua o libre de errores de la aplicación.',
              isDark,
            ),
            _buildSection(
              '8. Modificaciones',
              'Nos reservamos el derecho de actualizar o modificar estos términos en cualquier momento. Los cambios serán notificados en la aplicación y entrarán en vigor inmediatamente después de su publicación.',
              isDark,
            ),
            _buildSection(
              '9. Terminación',
              '• Puedes cancelar tu cuenta en cualquier momento desde la configuración de la app.\n'
              '• Nos reservamos el derecho de suspender o cancelar cuentas que violen estos términos.\n'
              '• Al cancelar tu cuenta, tus datos serán eliminados de nuestros sistemas.',
              isDark,
            ),
            _buildSection(
              '10. Ley aplicable',
              'Estos términos se rigen por las leyes de la República Bolivariana de Venezuela. Cualquier disputa será resuelta en los tribunales de la isla de Margarita.',
              isDark,
            ),
            _buildSection(
              '11. Contacto',
              'Para consultas, preguntas o notificaciones, contáctanos en:\n'
              '📧 contacto@serviciosmargarita.com\n'
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
              height: 1.5,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}