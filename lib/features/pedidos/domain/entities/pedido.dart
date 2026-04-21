import 'package:equatable/equatable.dart';
import 'item_pedido.dart';

class Pedido extends Equatable {
  final int            id;
  final int?           mesaId;
  final String         tipo;          // mesa | domicilio
  final double         valorDomicilio;
  final String         estado;        // abierto | cerrado | pagado
  final List<ItemPedido> items;
  final DateTime       creadoEn;

  const Pedido({
    required this.id,
    this.mesaId,
    required this.tipo,
    required this.valorDomicilio,
    required this.estado,
    required this.items,
    required this.creadoEn,
  });

  double get subtotal => items.fold(0, (s, i) => s + i.subtotal);
  double get total    => subtotal + (tipo == 'domicilio' ? valorDomicilio : 0);
  bool   get abierto  => estado == 'abierto';

  @override
  List<Object?> get props => [id, mesaId, estado, items];
}
