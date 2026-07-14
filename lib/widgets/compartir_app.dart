import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class CompartirApp {
  static void compartir(BuildContext context) {
    Share.share(
      '📱 Servicios Margarita\n'
      '\n'
      'Encuentra profesionales y servicios en Margarita.\n'
      'Conectamos la isla, un servicio a la vez.\n'
      '\n'
      '📥 Descárgala aquí:\n'
      'https://tusitio.com/servicios_margarita.apk\n'
      '\n'
      '🌊🚗🏪 ¡Conectamos la isla!',
    );
  }
}