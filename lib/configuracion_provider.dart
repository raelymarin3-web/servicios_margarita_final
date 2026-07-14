import 'package:flutter/material.dart';

class ConfiguracionProvider extends ChangeNotifier {
  bool _notificaciones = true;
  bool _sonido = true;
  bool _vibracion = false;
  bool _mostrarTelefono = true;
  bool _mostrarUbicacion = false;
  String _tema = 'Claro';
  String _idioma = 'Español';

  bool get notificaciones => _notificaciones;
  bool get sonido => _sonido;
  bool get vibracion => _vibracion;
  bool get mostrarTelefono => _mostrarTelefono;
  bool get mostrarUbicacion => _mostrarUbicacion;
  String get tema => _tema;
  String get idioma => _idioma;

  void setNotificaciones(bool value) {
    _notificaciones = value;
    notifyListeners();
  }

  void setSonido(bool value) {
    _sonido = value;
    notifyListeners();
  }

  void setVibracion(bool value) {
    _vibracion = value;
    notifyListeners();
  }

  void setMostrarTelefono(bool value) {
    _mostrarTelefono = value;
    notifyListeners();
  }

  void setMostrarUbicacion(bool value) {
    _mostrarUbicacion = value;
    notifyListeners();
  }

  void setTema(String value) {
    _tema = value;
    notifyListeners();
  }

  void setIdioma(String value) {
    _idioma = value;
    notifyListeners();
  }
}