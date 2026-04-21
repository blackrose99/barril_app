import 'package:equatable/equatable.dart';
import '../../../pedidos/domain/entities/pedido.dart';

class Factura extends Equatable {
  final int      id;
  final String   codigo;    // FAC-20250413-001
  final Pedido   pedido;
  final double   subtotal;
  final double   domicilio;
  final double   total;
  final String   estado;    // pendiente | pagada
  final DateTime creadaEn;

  const Factura({
    required this.id,
    required this.codigo,
    required this.pedido,
    required this.subtotal,
    required this.domicilio,
    required this.total,
    required this.estado,
    required this.creadaEn,
  });

  @override
  List<Object?> get props => [id, codigo, estado];
}
