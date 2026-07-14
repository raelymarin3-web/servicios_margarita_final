import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';

class FormularioServicioVarioScreen extends StatefulWidget {
  const FormularioServicioVarioScreen({super.key});

  @override
  State<FormularioServicioVarioScreen> createState() => _FormularioServicioVarioScreenState();
}

class _FormularioServicioVarioScreenState extends State<FormularioServicioVarioScreen> {
  // ============================================
  // ✅ FOTO DE PERFIL (NUEVO)
  // ============================================
  XFile? _fotoPerfil;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _localidadController = TextEditingController();
  final TextEditingController _especialidadController = TextEditingController();
  final TextEditingController _experienciaController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  String _tipoServicio = 'Mecánico';
  String _municipioSeleccionado = 'Maneiro';

  final List<String> _tiposServicio = [
    'Mecánico', 'Albañil', 'Carpintero', 'Electricista', 'Plomero',
    'Herrero', 'Pintor de brocha gorda', 'Jardinero', 'Cerrajero',
    'Técnico en refrigeración', 'Técnico en computación', 'Técnico en celulares',
    'Mudanzas', 'Chofer privado', 'Fletes de carga ligera',
    'Community Manager', 'Diseñador gráfico', 'Contador', 'Abogado',
    'Asistente administrativo', 'Profesor particular', 'Fotógrafo', 'Editor de video',
    'Repostero', 'Panadero', 'Peluquero', 'Barbero', 'Manicurista',
    'Maquillador', 'Esteticista', 'Masajista',
    'Personal de limpieza', 'Niñera (Cuidado de niños)', 'Paseador de perros',
    'Organizador de eventos', 'Sastre o costurero',
  ];

  final List<String> _municipios = [
    'Antolín del Campo', 'Díaz', 'Arismendi', 'García', 'Gómez',
    'Península de Macanao', 'Maneiro', 'Marcano', 'Mariño', 'Tubores',
  ];

  // ============================================
  // ✅ SELECCIONAR FOTO DE PERFIL (NUEVO)
  // ============================================
  Future<void> _seleccionarFotoPerfil() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _fotoPerfil = image;
      });
    }
  }

  // ============================================
  // GUARDAR
  // ============================================
  void _guardar() {
    if (_nombreController.text.isEmpty || _telefonoController.text.isEmpty) {
      _mostrarMensaje('⚠️ Completa todos los campos obligatorios');
      return;
    }

    // ✅ VALIDACIÓN DE FOTO DE PERFIL (NUEVO)
    if (_fotoPerfil == null) {
      _mostrarMensaje('⚠️ Debes subir una foto de perfil');
      return;
    }

    final nuevoServicio = {
      'tipo': _tipoServicio.toLowerCase(),
      'nombre': _nombreController.text,
      'telefono': _telefonoController.text,
      'municipio': _municipioSeleccionado,
      'localidad': _localidadController.text,
      'especialidad': _especialidadController.text,
      'experiencia': _experienciaController.text,
      'descripcion': _descripcionController.text,
      'fotoPerfil': _fotoPerfil?.path ?? '', // ✅ GUARDAR RUTA DE FOTO DE PERFIL
      'redes': {
        'instagram': _instagramController.text,
        'facebook': _facebookController.text,
        'twitter': _twitterController.text,
        'whatsapp': _whatsappController.text,
      },
    };

    final dataService = Provider.of<DataService>(context, listen: false);
    dataService.agregarServicio(nuevoServicio);

    _mostrarMensaje('✅ Servicio registrado exitosamente');
    _limpiarCampos();
  }

  void _limpiarCampos() {
    _nombreController.clear();
    _telefonoController.clear();
    _localidadController.clear();
    _especialidadController.clear();
    _experienciaController.clear();
    _descripcionController.clear();
    _instagramController.clear();
    _facebookController.clear();
    _twitterController.clear();
    _whatsappController.clear();
    setState(() {
      _fotoPerfil = null; // ✅ LIMPIAR FOTO DE PERFIL
    });
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: const Duration(seconds: 2),
        backgroundColor: mensaje.contains('✅') ? Colors.green : Colors.orange,
      ),
    );
  }

  void _abrirRedSocial(String? url) {
    if (url == null || url.isEmpty) {
      _mostrarMensaje('⚠️ No hay URL configurada');
      return;
    }
    _mostrarMensaje('🔗 Abriendo: $url');
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool required = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hintText,
        hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[400]),
        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.blue) : null,
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
    );
  }

  // ============================================
  // ✅ WIDGET PARA FOTO DE PERFIL (NUEVO)
  // ============================================
  Widget _buildFotoPerfil() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: _seleccionarFotoPerfil,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            _fotoPerfil != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(_fotoPerfil!.path),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[700] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add_photo_alternate, color: Colors.grey),
                  ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _fotoPerfil != null ? '✅ Foto de perfil' : '📸 Subir foto de perfil *',
                style: TextStyle(
                  color: _fotoPerfil != null 
                      ? Colors.green 
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  fontWeight: _fotoPerfil != null ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔨 Registrar Servicio'),
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
            const Text(
              'Datos del Servicio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 16),

            // ============================================
            // ✅ FOTO DE PERFIL (NUEVO)
            // ============================================
            _buildFotoPerfil(),
            const SizedBox(height: 16),

            // Tipo de servicio
            DropdownButtonFormField<String>(
              value: _tipoServicio,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              dropdownColor: isDark ? Colors.grey[800] : Colors.white,
              decoration: InputDecoration(
                labelText: 'Tipo de servicio *',
                labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
                prefixIcon: const Icon(Icons.category, color: Colors.blue),
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
              items: _tiposServicio.map((String tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Text(tipo, style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _tipoServicio = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Nombre
            _buildTextField(
              controller: _nombreController,
              label: 'Nombres completos',
              prefixIcon: Icons.person,
              required: true,
            ),
            const SizedBox(height: 16),

            // Teléfono
            _buildTextField(
              controller: _telefonoController,
              label: 'Teléfono',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              required: true,
            ),
            const SizedBox(height: 16),

            // ============================================
            // MUNICIPIO
            // ============================================
            DropdownButtonFormField<String>(
              value: _municipioSeleccionado,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              dropdownColor: isDark ? Colors.grey[800] : Colors.white,
              decoration: InputDecoration(
                labelText: 'Municipio *',
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
                  _municipioSeleccionado = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // ============================================
            // LOCALIDAD (ESCRITO A MANO)
            // ============================================
            _buildTextField(
              controller: _localidadController,
              label: 'Localidad / Dirección',
              hintText: 'Ej: Calle 5, El Morro',
              prefixIcon: Icons.home,
              required: true,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _especialidadController,
              label: 'Especialidad',
              prefixIcon: Icons.star,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _experienciaController,
              label: 'Años de experiencia',
              prefixIcon: Icons.timeline,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _descripcionController,
              label: 'Descripción',
              prefixIcon: Icons.description,
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            const Text(
              '🌐 Redes Sociales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            const Text('Opcional: agrega tus redes sociales', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _instagramController,
              label: 'Instagram',
              hintText: 'https://instagram.com/tu_usuario',
              prefixIcon: Icons.camera_alt,
            ),
            const SizedBox(height: 12),

            _buildTextField(
              controller: _facebookController,
              label: 'Facebook',
              hintText: 'https://facebook.com/tu_pagina',
              prefixIcon: Icons.facebook,
            ),
            const SizedBox(height: 12),

            _buildTextField(
              controller: _twitterController,
              label: 'Twitter / X',
              hintText: 'https://twitter.com/tu_usuario',
              prefixIcon: Icons.alternate_email,
            ),
            const SizedBox(height: 12),

            _buildTextField(
              controller: _whatsappController,
              label: 'WhatsApp',
              hintText: 'https://wa.me/58412XXXXXXX',
              prefixIcon: Icons.chat,
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: const Text('💾 Guardar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              '📱 Redes Sociales (vista previa)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
              ),
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildSocialButton(
                    icon: Icons.camera_alt,
                    color: Colors.pink,
                    label: 'Instagram',
                    url: _instagramController.text,
                  ),
                  _buildSocialButton(
                    icon: Icons.facebook,
                    color: Colors.blue,
                    label: 'Facebook',
                    url: _facebookController.text,
                  ),
                  _buildSocialButton(
                    icon: Icons.alternate_email,
                    color: Colors.black,
                    label: 'Twitter/X',
                    url: _twitterController.text,
                  ),
                  _buildSocialButton(
                    icon: Icons.chat,
                    color: Colors.green,
                    label: 'WhatsApp',
                    url: _whatsappController.text,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('← Volver', style: TextStyle(fontSize: 16, color: Colors.blue)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required String label,
    required String url,
  }) {
    final bool tieneUrl = url.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: tieneUrl ? () => _abrirRedSocial(url) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: tieneUrl ? color.withOpacity(0.15) : (isDark ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: tieneUrl ? color : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: tieneUrl ? color : Colors.grey, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: tieneUrl ? color : Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
            if (tieneUrl) const Icon(Icons.open_in_new, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}