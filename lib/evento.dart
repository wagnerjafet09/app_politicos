import 'dart:io';

class Evento {
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final File? imagen;
  final String audioPath;

  Evento({
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.imagen,
    required this.audioPath,
  });
  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fecha: DateTime.parse(json['fecha']),
      imagen: File(json[
          'imagen']), // Asegúrate de que esta conversión sea correcta para tu caso
      audioPath: json['audioPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
      'imagen': imagen
          ?.path, // Asegúrate de que esta conversión sea correcta para tu caso
      'audioPath': audioPath,
    };
  }
}
