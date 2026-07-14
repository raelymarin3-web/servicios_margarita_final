import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PerfilUsuarioScreen extends StatefulWidget {
  const PerfilUsuarioScreen({super.key});

  @override
  State<PerfilUsuarioScreen> createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends State<PerfilUsuarioScreen> {
  String _nombre = 'Juan Pérez';
  String _telefono = '04121234567';
  String _email = 'juan@email.com';
  String _zona = 'Porlamar';
  XFile? _fotoPerfil;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _zonaController = TextEditingController();

  bool _editando = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() {
    _nombreController.text = _nombre;
    _telefonoController.text = _telefono;
    _emailController.text = _email;
    _zonaController.text = _zona;
  }

  Future<void> _seleccionarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _fotoPerfil = image;
      });
    }
  }

  void _guardarCambios() {
    setState(() {
      _nombre = _nombreController.text;
      _telefono = _telefonoController.text;
      _email = _emailController.text;
      _zona = _zonaController.text;
      _editando = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Perfil actualizado'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _cancelarEdicion() {
    setState(() {
      _editando = false;
    });
    _cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👤 Mi Perfil'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_editando)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() {
                  _editando = true;
                });
              },
              tooltip: 'Editar perfil',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _editando ? _seleccionarFoto : null,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _fotoPerfil != null
                        ? FileImage(File(_fotoPerfil!.path))
                        : null,
                    child: _fotoPerfil == null
                        ? Text(
                            _nombre.isNotEmpty ? _nombre[0].toUpperCase() : '?',
                            style: const TextStyle(fontSize: 40, color: Colors.blue),
                          )
                        : null,
                  ),
                  if (_editando)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (_editando)
              Text(
                'Toca la foto para cambiarla',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            const SizedBox(height: 24),

            _buildCampo(
              label: 'Nombres',
              controller: _nombreController,
              habilitado: _editando,
              icon: Icons.person,
            ),
            const SizedBox(height: 16),

            _buildCampo(
              label: 'Teléfono',
              controller: _telefonoController,
              habilitado: _editando,
              icon: Icons.phone,
            ),
            const SizedBox(height: 16),

            _buildCampo(
              label: 'Email',
              controller: _emailController,
              habilitado: _editando,
              icon: Icons.email,
            ),
            const SizedBox(height: 16),

            _buildCampo(
              label: 'Zona de trabajo',
              controller: _zonaController,
              habilitado: _editando,
              icon: Icons.location_on,
            ),
            const SizedBox(height: 32),

            if (_editando)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _cancelarEdicion,
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
                      onPressed: _guardarCambios,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text('💾 Guardar'),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 32),

            const Text(
              '📊 Estadísticas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatCard(
                  icon: Icons.business_center,
                  label: 'Servicios',
                  value: '3',
                  color: Colors.blue,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  icon: Icons.star,
                  label: 'Calificación',
                  value: '4.8',
                  color: Colors.amber,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  icon: Icons.people,
                  label: 'Clientes',
                  value: '12',
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 32),

            Center(
              child: Text(
                'Servicios Margarita v1.0.0',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCampo({
    required String label,
    required TextEditingController controller,
    required bool habilitado,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      enabled: habilitado,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: habilitado ? Colors.white : Colors.grey[50],
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      style: TextStyle(
        color: habilitado ? Colors.black : Colors.grey[700],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}