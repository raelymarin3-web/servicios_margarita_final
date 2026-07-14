import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../models/patrocinador.dart';
import 'detalle_patrocinador_screen.dart';

class PatrocinadoresScreen extends StatelessWidget {
  const PatrocinadoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patrocinadores = Provider.of<DataService>(context).patrocinadores;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ✅ ORDENAR POR CALIFICACIÓN (DE MAYOR A MENOR)
    final patrocinadoresOrdenados = List<Patrocinador>.from(patrocinadores)
      ..sort((a, b) => b.calificacion.compareTo(a.calificacion));

    // ✅ LOS DESTACADOS PRIMERO (OPCIONAL)
    // final patrocinadoresOrdenados = List<Patrocinador>.from(patrocinadores)
    //   ..sort((a, b) {
    //     // Primero destacados
    //     if (a.destacado && !b.destacado) return -1;
    //     if (!a.destacado && b.destacado) return 1;
    //     // Luego por calificación
    //     return b.calificacion.compareTo(a.calificacion);
    //   });

    return Scaffold(
      appBar: AppBar(
        title: const Text('⭐ Aliados de Margarita'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: patrocinadoresOrdenados.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No hay patrocinadores aún',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pronto tendremos aliados locales',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemCount: patrocinadoresOrdenados.length,
              itemBuilder: (context, index) {
                final p = patrocinadoresOrdenados[index];
                return _buildPatrocinadorCard(p, context, isDark, index + 1);
              },
            ),
    );
  }

  Widget _buildPatrocinadorCard(
    Patrocinador p,
    BuildContext context,
    bool isDark,
    int posicion,
  ) {
    // ✅ COLOR DEL PUESTO
    Color? puestoColor;
    if (posicion == 1) {
      puestoColor = Colors.amber; // 🥇 Oro
    } else if (posicion == 2) {
      puestoColor = Colors.grey[400]; // 🥈 Plata
    } else if (posicion == 3) {
      puestoColor = Colors.brown[300]; // 🥉 Bronce
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: p.destacado
            ? BorderSide(color: Colors.amber[700]!, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetallePatrocinadorScreen(patrocinador: p),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ============================================
              // LOGO / ICONO CON PUESTO
              // ============================================
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.business,
                        size: 28,
                        color: p.destacado ? Colors.amber : Colors.blue,
                      ),
                    ),
                  ),
                  // ✅ MEDALLA DEL PUESTO
                  if (posicion <= 3)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: puestoColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            posicion.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // ============================================
              // NOMBRE
              // ============================================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (p.destacado)
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      p.nombre,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // ============================================
              // CALIFICACIÓN
              // ============================================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    ' ${p.calificacion}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    ' (${p.totalOpiniones})',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // ============================================
              // DIRECCIÓN
              // ============================================
              Text(
                p.direccion,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // ============================================
              // OFERTA
              // ============================================
              if (p.ofertas.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_offer, color: Colors.orange, size: 12),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          p.ofertas.first,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}