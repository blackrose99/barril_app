import '../../../../core/usecases/usecase.dart';
import '../entities/pedido.dart';
import '../repositories/pedido_repository.dart';

class ObtenerPedidoAbiertoPorMesaParams {
  final int mesaId;
  const ObtenerPedidoAbiertoPorMesaParams(this.mesaId);
}

class ObtenerPedidoAbiertoPorMesa
    extends UseCase<Pedido?, ObtenerPedidoAbiertoPorMesaParams> {
  final PedidoRepository repository;
  ObtenerPedidoAbiertoPorMesa(this.repository);

  @override
  Future<Pedido?> call(ObtenerPedidoAbiertoPorMesaParams params) {
    return repository.obtenerPedidoAbiertoPorMesa(params.mesaId);
  }
}
