import '../../../../core/usecases/usecase.dart';
import '../entities/mesa.dart';
import '../repositories/pedido_repository.dart';

class ObtenerMesas extends UseCase<List<Mesa>, NoParams> {
  final PedidoRepository repository;
  ObtenerMesas(this.repository);

  @override
  Future<List<Mesa>> call(NoParams params) =>
      repository.obtenerMesas();
}
