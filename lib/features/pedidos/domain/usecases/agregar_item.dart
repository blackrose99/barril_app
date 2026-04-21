import '../../../../core/usecases/usecase.dart';
import '../entities/item_pedido.dart';
import '../repositories/pedido_repository.dart';

class AgregarItem extends UseCase<void, ItemPedido> {
  final PedidoRepository repository;
  AgregarItem(this.repository);

  @override
  Future<void> call(ItemPedido params) =>
      repository.agregarItem(params);
}
