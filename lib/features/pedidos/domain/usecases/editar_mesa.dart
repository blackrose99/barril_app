import '../../../../core/usecases/usecase.dart';
import '../repositories/pedido_repository.dart';

class EditarMesaParams {
  final int mesaId;
  final String nombre;

  const EditarMesaParams({
    required this.mesaId,
    required this.nombre,
  });
}

class EditarMesa extends UseCase<void, EditarMesaParams> {
  final PedidoRepository repository;
  EditarMesa(this.repository);

  @override
  Future<void> call(EditarMesaParams params) => repository.editarMesa(
        mesaId: params.mesaId,
        nombre: params.nombre,
      );
}
