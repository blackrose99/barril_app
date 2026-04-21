import 'package:equatable/equatable.dart';
import 'categoria.dart';

class Producto extends Equatable {
  final int       id;
  final Categoria categoria;
  final String    nombre;
  final String    descripcion;
  final double    precio;
  final bool      activo;

  const Producto({
    required this.id,
    required this.categoria,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.activo,
  });

  @override
  List<Object?> get props => [id, nombre, precio];
}
