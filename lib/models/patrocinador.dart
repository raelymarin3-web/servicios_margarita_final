class Patrocinador {
  final String id;
  final String nombre;
  final String logoUrl;
  final String descripcion;
  final String direccion;
  final String telefono;
  final String whatsapp;
  final String horario;
  final String web;
  final double calificacion;
  final int totalOpiniones;
  final List<String> redesSociales;
  final List<String> ofertas;
  final bool destacado;
  final String categoria;

  Patrocinador({
    required this.id,
    required this.nombre,
    required this.logoUrl,
    required this.descripcion,
    required this.direccion,
    required this.telefono,
    required this.whatsapp,
    required this.horario,
    this.web = '',
    this.calificacion = 0.0,
    this.totalOpiniones = 0,
    this.redesSociales = const [],
    this.ofertas = const [],
    this.destacado = false,
    this.categoria = 'Patrocinadores',
  });

  factory Patrocinador.fromJson(Map<String, dynamic> json) {
    return Patrocinador(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? 'Sin nombre',
      logoUrl: json['logoUrl'] ?? '',
      descripcion: json['descripcion'] ?? '',
      direccion: json['direccion'] ?? '',
      telefono: json['telefono'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      horario: json['horario'] ?? '',
      web: json['web'] ?? '',
      calificacion: (json['calificacion'] ?? 0.0).toDouble(),
      totalOpiniones: json['totalOpiniones'] ?? 0,
      redesSociales: List<String>.from(json['redesSociales'] ?? []),
      ofertas: List<String>.from(json['ofertas'] ?? []),
      destacado: json['destacado'] ?? false,
      categoria: json['categoria'] ?? 'Patrocinadores',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'logoUrl': logoUrl,
      'descripcion': descripcion,
      'direccion': direccion,
      'telefono': telefono,
      'whatsapp': whatsapp,
      'horario': horario,
      'web': web,
      'calificacion': calificacion,
      'totalOpiniones': totalOpiniones,
      'redesSociales': redesSociales,
      'ofertas': ofertas,
      'destacado': destacado,
      'categoria': categoria,
    };
  }
}