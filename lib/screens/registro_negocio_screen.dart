import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../services/data_service.dart';

class RegistroNegocioScreen extends StatefulWidget {
  const RegistroNegocioScreen({super.key});

  @override
  State<RegistroNegocioScreen> createState() => _RegistroNegocioScreenState();
}

class _RegistroNegocioScreenState extends State<RegistroNegocioScreen> {
  // ============================================
  // CONSTANTE: LÍMITE DE FOTOS
  // ============================================
  static const int MAX_FOTOS = 4;

  // ============================================
  // ✅ FOTO DE PERFIL (NUEVO)
  // ============================================
  XFile? _fotoPerfil;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _horarioController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _localidadController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  String _municipioSeleccionado = 'Maneiro';
  bool _tieneDelivery = false;
  List<XFile> _fotosProductos = [];

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
  // SELECCIONAR FOTOS DE PRODUCTOS (CON LÍMITE DE 4)
  // ============================================
  Future<void> _seleccionarFotos() async {
    if (_fotosProductos.length >= MAX_FOTOS) {
      _mostrarMensaje('⚠️ Máximo $MAX_FOTOS fotos permitidas');
      return;
    }

    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      final restantes = MAX_FOTOS - _fotosProductos.length;
      final seleccionadas = images.take(restantes).toList();

      setState(() {
        _fotosProductos.addAll(seleccionadas);
      });

      final mensaje = seleccionadas.length < images.length
          ? '📸 Se agregaron ${seleccionadas.length} fotos (máximo $MAX_FOTOS)'
          : '📸 ${seleccionadas.length} fotos agregadas';
      _mostrarMensaje(mensaje);
    }
  }

  void _eliminarFoto(int index) {
    setState(() {
      _fotosProductos.removeAt(index);
    });
  }

  // ============================================
  // GUARDAR NEGOCIO
  // ============================================
  void _guardarNegocio() {
    if (_nombreController.text.isEmpty) {
      _mostrarMensaje('⚠️ El nombre del negocio es obligatorio');
      return;
    }
    if (_direccionController.text.isEmpty) {
      _mostrarMensaje('⚠️ La dirección es obligatoria');
      return;
    }
    if (_horarioController.text.isEmpty) {
      _mostrarMensaje('⚠️ El horario es obligatorio');
      return;
    }
    if (_telefonoController.text.isEmpty) {
      _mostrarMensaje('⚠️ El teléfono es obligatorio');
      return;
    }

    // ✅ VALIDACIÓN DE FOTO DE PERFIL (NUEVO)
    if (_fotoPerfil == null) {
      _mostrarMensaje('⚠️ Debes subir una foto de perfil');
      return;
    }

    final nuevoServicio = {
      'tipo': 'negocio',
      'nombre': _nombreController.text,
      'direccion': _direccionController.text,
      'horario': _horarioController.text,
      'telefono': _telefonoController.text,
      'municipio': _municipioSeleccionado,
      'localidad': _localidadController.text,
      'descripcion': _descripcionController.text,
      'delivery': _tieneDelivery,
      'fotoPerfil': _fotoPerfil?.path ?? '', // ✅ GUARDAR RUTA DE FOTO DE PERFIL
      'fotos': _fotosProductos.map((f) => f.path).toList(),
      'redes': {
        'instagram': _instagramController.text,
        'facebook': _facebookController.text,
        'twitter': _twitterController.text,
        'whatsapp': _whatsappController.text,
      },
    };

    final dataService = Provider.of<DataService>(context, listen: false);
    dataService.agregarServicio(nuevoServicio);

    _mostrarMensaje('✅ Negocio registrado exitosamente');
    _limpiarCampos();
  }

  void _limpiarCampos() {
    _nombreController.clear();
    _direccionController.clear();
    _horarioController.clear();
    _telefonoController.clear();
    _localidadController.clear();
    _descripcionController.clear();
    _instagramController.clear();
    _facebookController.clear();
    _twitterController.clear();
    _whatsappController.clear();
    setState(() {
      _fotoPerfil = null; // ✅ LIMPIAR FOTO DE PERFIL
      _fotosProductos.clear();
      _tieneDelivery = false;
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

  // ============================================
  // WIDGET REUTILIZABLE PARA TEXTFIELD CON TEMA OSCURO
  // ============================================
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
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark ? Colors.grey[500] : Colors.grey[400],
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.grey[700],
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.blue) : null,
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
        title: const Text('🏪 Registrar Negocio'),
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
              'Datos del Negocio',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            const Text(
              'Completa los datos para registrar tu negocio',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // ============================================
            // ✅ FOTO DE PERFIL (NUEVO)
            // ============================================
            _buildFotoPerfil(),
            const SizedBox(height: 16),

            // ============================================
            // CAMPOS DEL FORMULARIO
            // ============================================
            _buildTextField(
              controller: _nombreController,
              label: 'Nombre del negocio',
              hintText: 'Ej: Bodega El Amigo',
              prefixIcon: Icons.store,
              required: true,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _direccionController,
              label: 'Dirección',
              hintText: 'Ej: Calle Principal, Porlamar',
              prefixIcon: Icons.location_on,
              required: true,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _horarioController,
              label: 'Horario de atención',
              hintText: 'Ej: Lunes a Sábado 8am - 8pm',
              prefixIcon: Icons.access_time,
              required: true,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _telefonoController,
              label: 'Teléfono de contacto',
              hintText: 'Ej: 04121234567',
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
            // LOCALIDAD
            // ============================================
            _buildTextField(
              controller: _localidadController,
              label: 'Localidad / Dirección exacta',
              hintText: 'Ej: Calle 5, El Morro',
              prefixIcon: Icons.home,
              required: true,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _descripcionController,
              label: 'Descripción',
              hintText: 'Describe tu negocio...',
              prefixIcon: Icons.description,
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // ============================================
            // DELIVERY
            // ============================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.delivery_dining, color: Colors.blue),
                  const SizedBox(width: 12),
                  const Text(
                    '¿Ofrece Delivery?',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  Switch(
                    value: _tieneDelivery,
                    onChanged: (value) {
                      setState(() {
                        _tieneDelivery = value;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ============================================
            // FOTOS DE PRODUCTOS (MÁXIMO 4)
            // ============================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📸 Fotos de productos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                Text(
                  '${_fotosProductos.length}/$MAX_FOTOS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _fotosProductos.length >= MAX_FOTOS ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _fotosProductos.length >= MAX_FOTOS ? null : _seleccionarFotos,
              icon: const Icon(Icons.add_photo_alternate),
              label: Text(
                _fotosProductos.length >= MAX_FOTOS
                    ? 'Límite alcanzado ($MAX_FOTOS)'
                    : 'Agregar fotos (${MAX_FOTOS - _fotosProductos.length} restantes)',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _fotosProductos.length >= MAX_FOTOS ? Colors.grey : Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            // Grid de fotos seleccionadas
            if (_fotosProductos.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _fotosProductos.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_fotosProductos[index].path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _eliminarFoto(index),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      if (_fotosProductos.length == MAX_FOTOS && index == _fotosProductos.length - 1)
                        Positioned(
                          bottom: 4,
                          left: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Máximo alcanzado',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            const SizedBox(height: 24),

            // ============================================
            // REDES SOCIALES
            // ============================================
            const Text(
              '🌐 Redes Sociales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            const Text(
              'Opcional: agrega los enlaces a tus redes sociales',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
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

            // ============================================
            // BOTÓN GUARDAR
            // ============================================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _guardarNegocio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: const Text(
                  '💾 Guardar Negocio',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ============================================
            // VISTA PREVIA DE REDES SOCIALES
            // ============================================
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
            const SizedBox(height: 32),

            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  '← Volver',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 20),
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