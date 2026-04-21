import 'package:equatable/equatable.dart';

class Categoria extends Equatable {
  final int    id;
  final String nombre;
  final int    orden;

  const Categoria({
    required this.id,
    required this.nombre,
    required this.orden,
  });

  @override
  List<Object?> get props => [id, nombre];
}
