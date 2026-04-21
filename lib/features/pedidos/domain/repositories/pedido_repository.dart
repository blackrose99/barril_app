import '../entities/mesa.dart';
import '../entities/pedido.dart';
import '../entities/item_pedido.dart';

abstract class PedidoRepository {
  Future<List<Mesa>> obtenerMesas();
  Future<int> crearMesa({String? nombre});
  Future<void> editarMesa({required int mesaId, required String nombre});
  Future<Pedido?> obtenerPedidoAbiertoPorMesa(int mesaId);
  Future<int> crearPedido(
      {required int? mesaId, required String tipo, double valorDomicilio = 0});
  Future<void> agregarItem(ItemPedido item);
  Future<void> editarItem(ItemPedido item);
  Future<void> eliminarItem(int itemId);
  Future<void> cerrarPedido(int pedidoId);
  Future<List<Pedido>> obtenerPedidosDelDia();
}
