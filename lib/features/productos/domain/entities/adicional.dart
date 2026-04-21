import 'package:equatable/equatable.dart';

class Adicional extends Equatable {
  final int    id;
  final String nombre;
  final bool   activo;

  const Adicional({
    required this.id,
    required this.nombre,
    required this.activo,
  });

  @override
  List<Object?> get props => [id, nombre];
}
