import '../../../../core/usecases/usecase.dart';
import '../repositories/pedido_repository.dart';

class CrearMesaParams {
  final String? nombre;

  const CrearMesaParams({this.nombre});
}

class CrearMesa extends UseCase<int, CrearMesaParams> {
  final PedidoRepository repository;
  CrearMesa(this.repository);

  @override
  Future<int> call(CrearMesaParams params) =>
      repository.crearMesa(nombre: params.nombre);
}
