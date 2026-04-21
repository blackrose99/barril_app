import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/item_pedido.dart';
import '../../domain/entities/mesa.dart';
import '../../domain/entities/pedido.dart';
import '../../domain/usecases/agregar_item.dart';
import '../../domain/usecases/cerrar_cuenta.dart';
import '../../domain/usecases/obtener_mesas.dart';
import '../../domain/usecases/obtener_pedido_abierto_por_mesa.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../injection_container.dart';

// --- Mesas ---
final mesasProvider = FutureProvider<List<Mesa>>((ref) async {
  return sl<ObtenerMesas>().call(NoParams());
});

// --- Pedido activo por mesa ---
final pedidoActivoProvider =
    FutureProvider.family<Pedido?, int>((ref, mesaId) async {
  return sl<ObtenerPedidoAbiertoPorMesa>()
      .call(ObtenerPedidoAbiertoPorMesaParams(mesaId));
});

// --- Notifier del pedido en curso ---
class PedidoNotifier extends StateNotifier<Pedido?> {
  PedidoNotifier() : super(null);

  void cargar(Pedido pedido) => state = pedido;

  void limpiar() => state = null;

  Future<void> agregarItem(ItemPedido item) async {
    await sl<AgregarItem>().call(item);
    if (state != null) {
      state = Pedido(
        id: state!.id,
        mesaId: state!.mesaId,
        tipo: state!.tipo,
        valorDomicilio: state!.valorDomicilio,
        estado: state!.estado,
        items: [...state!.items, item],
        creadoEn: state!.creadoEn,
      );
    }
  }

  Future<void> cerrar() async {
    if (state != null) {
      await sl<CerrarCuenta>().call(state!.id);
      state = null;
    }
  }
}

final pedidoNotifierProvider =
    StateNotifierProvider<PedidoNotifier, Pedido?>((ref) => PedidoNotifier());
