import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';

class FormularioTaxiScreen extends StatefulWidget {
  final String tipo; // 'taxi' o 'moto_taxi'

  const FormularioTaxiScreen({super.key, required this.tipo});

  @override
  State<FormularioTaxiScreen> createState() => _FormularioTaxiScreenState();
}

class _FormularioTaxiScreenState extends State<FormularioTaxiScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _localidadController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _tarifaController = TextEditingController();

  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  String _municipioSeleccionado = 'Maneiro';
  XFile? _fotoPerfil;
  XFile? _fotoCedula;
  XFile? _fotoLicencia;
  XFile? _fotoCarro;

  final List<String> _municipios = [
    'Antolín del Campo', 'Díaz', 'Arismendi', 'García', 'Gómez',
    'Península de Macanao', 'Maneiro', 'Marcano', 'Mariño', 'Tubores',
  ];

  Future<void> _seleccionarFoto(String tipo) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        switch (tipo) {
          case 'perfil':
            _fotoPerfil = image;
            break;
          case 'cedula':
            _fotoCedula = image;
            break;
          case 'licencia':
            _fotoLicencia = image;
            break;
          case 'carro':
            _fotoCarro = image;
            break;
        }
      });
    }
  }

  void _guardar() {
    if (_nombreController.text.isEmpty ||
        _telefonoController.text.isEmpty ||
        _placaController.text.isEmpty ||
        _modeloController.text.isEmpty) {
      _mostrarMensaje('⚠️ Completa todos los campos obligatorios');
      return;
    }

    if (_fotoPerfil == null) {
      _mostrarMensaje('⚠️ Debes subir una foto de perfil');
      return;
    }

    if (_fotoCedula == null) {
      _mostrarMensaje('⚠️ Debes subir una foto de tu cédula');
      return;
    }

    if (_fotoLicencia == null) {
      _mostrarMensaje('⚠️ Debes subir una foto de tu licencia');
      return;
    }

    final nuevoServicio = {
      'tipo': widget.tipo == 'taxi' ? 'taxi' : 'moto_taxi',
      'nombre': _nombreController.text,
      'telefono': _telefonoController.text,
      'municipio': _municipioSeleccionado,
      'localidad': _localidadController.text,
      'placa': _placaController.text,
      'modelo': _modeloController.text,
      'ano': _anoController.text,
      'color': _colorController.text,
      'tarifa': _tarifaController.text,
      'redes': {
        'instagram': _instagramController.text,
        'facebook': _facebookController.text,
        'twitter': _twitterController.text,
        'whatsapp': _whatsappController.text,
      },
    };

    final dataService = Provider.of<DataService>(context, listen: false);
    dataService.agregarServicio(nuevoServicio);

    _mostrarMensaje('✅ ${widget.tipo == 'taxi' ? 'Taxi' : 'Moto Taxi'} registrado exitosamente');
    _limpiarCampos();
  }

  void _limpiarCampos() {
    _nombreController.clear();
    _telefonoController.clear();
    _localidadController.clear();
    _placaController.clear();
    _modeloController.clear();
    _anoController.clear();
    _colorController.clear();
    _tarifaController.clear();
    _instagramController.clear();
    _facebookController.clear();
    _twitterController.clear();
    _whatsappController.clear();
    setState(() {
      _fotoPerfil = null;
      _fotoCedula = null;
      _fotoLicencia = null;
      _fotoCarro = null;
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

  Widget _buildFotoPicker({
    required String label,
    required XFile? image,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
        ),
        child: Row(
          children: [
            image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(image.path),
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
                image != null ? '✅ $label' : label,
                style: TextStyle(
                  color: image != null ? Colors.green : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  fontWeight: image != null ? FontWeight.bold : FontWeight.normal,
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
    final String titulo = widget.tipo == 'taxi' ? '🚗 Registrar Taxi' : '🛵 Registrar Moto Taxi';
    final String vehiculo = widget.tipo == 'taxi' ? 'Carro' : 'Moto';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Datos Personales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 16),

            _buildFotoPicker(
              label: 'Foto de perfil *',
              image: _fotoPerfil,
              onTap: () => _seleccionarFoto('perfil'),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _nombreController,
              label: 'Nombres completos',
              prefixIcon: Icons.person,
              required: true,
            ),
            const SizedBox(height: 16),

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
            // LOCALIDAD
            // ============================================
            _buildTextField(
              controller: _localidadController,
              label: 'Localidad / Dirección',
              hintText: 'Ej: Calle 5, El Morro',
              prefixIcon: Icons.home,
              required: true,
            ),
            const SizedBox(height: 16),

            const Text(
              'Documentos (Privados - Solo para verificación)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 16),

            _buildFotoPicker(
              label: 'Foto de cédula *',
              image: _fotoCedula,
              onTap: () => _seleccionarFoto('cedula'),
            ),
            const SizedBox(height: 16),

            _buildFotoPicker(
              label: 'Foto de licencia *',
              image: _fotoLicencia,
              onTap: () => _seleccionarFoto('licencia'),
            ),
            const SizedBox(height: 16),

            const Text(
              'Datos del Vehículo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 16),

            _buildFotoPicker(
              label: 'Foto del $vehiculo (opcional)',
              image: _fotoCarro,
              onTap: () => _seleccionarFoto('carro'),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _placaController,
              label: 'Placa',
              prefixIcon: Icons.confirmation_number,
              required: true,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _modeloController,
              label: 'Modelo',
              prefixIcon: Icons.directions_car,
              required: true,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _anoController,
              label: 'Año (opcional)',
              prefixIcon: Icons.calendar_today,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _colorController,
              label: 'Color (opcional)',
              prefixIcon: Icons.color_lens,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _tarifaController,
              label: 'Tarifa base (opcional)',
              prefixIcon: Icons.attach_money,
              keyboardType: TextInputType.number,
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