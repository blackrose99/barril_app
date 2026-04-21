import 'package:equatable/equatable.dart';

class ItemPedido extends Equatable {
  final int          id;
  final int          pedidoId;
  final int          productoId;
  final String       nombreProducto;
  final double       precio;
  final int          cantidad;
  final List<String> adicionales;
  final String       nota;

  const ItemPedido({
    required this.id,
    required this.pedidoId,
    required this.productoId,
    required this.nombreProducto,
    required this.precio,
    required this.cantidad,
    required this.adicionales,
    required this.nota,
  });

  double get subtotal => precio * cantidad;

  @override
  List<Object?> get props => [id, pedidoId, productoId, cantidad, adicionales];
}
