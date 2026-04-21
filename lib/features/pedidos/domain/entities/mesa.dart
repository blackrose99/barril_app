import 'package:equatable/equatable.dart';

class Mesa extends Equatable {
  final int    id;
  final String nombre;
  final String estado; // libre | ocupada

  const Mesa({
    required this.id,
    required this.nombre,
    required this.estado,
  });

  bool get estaLibre   => estado == 'libre';
  bool get estaOcupada => estado == 'ocupada';

  @override
  List<Object?> get props => [id, nombre, estado];
}
