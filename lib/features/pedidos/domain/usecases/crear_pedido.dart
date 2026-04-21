import '../../../../core/usecases/usecase.dart';
import '../repositories/pedido_repository.dart';

class CrearPedidoParams {
  final int?   mesaId;
  final String tipo;
  final double valorDomicilio;

  const CrearPedidoParams({
    this.mesaId,
    required this.tipo,
    this.valorDomicilio = 0,
  });
}

class CrearPedido extends UseCase<int, CrearPedidoParams> {
  final PedidoRepository repository;
  CrearPedido(this.repository);

  @override
  Future<int> call(CrearPedidoParams params) =>
      repository.crearPedido(
        mesaId:         params.mesaId,
        tipo:           params.tipo,
        valorDomicilio: params.valorDomicilio,
      );
}
