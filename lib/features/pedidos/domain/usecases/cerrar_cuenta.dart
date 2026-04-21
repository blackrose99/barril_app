import '../../../../core/usecases/usecase.dart';
import '../repositories/pedido_repository.dart';

class CerrarCuenta extends UseCase<void, int> {
  final PedidoRepository repository;
  CerrarCuenta(this.repository);

  @override
  Future<void> call(int pedidoId) =>
      repository.cerrarPedido(pedidoId);
}
