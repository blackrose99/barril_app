import 'package:drift/drift.dart';
import '../../../../database/app_database.dart' as db;
import '../../domain/entities/item_pedido.dart';
import '../../domain/entities/mesa.dart';
import '../../domain/entities/pedido.dart';
import '../../domain/repositories/pedido_repository.dart';
import '../datasources/pedido_local_datasource.dart';
import '../models/item_pedido_model.dart';
import '../models/mesa_model.dart';

class PedidoRepositoryImpl implements PedidoRepository {
  final PedidoLocalDatasource datasource;
  PedidoRepositoryImpl(this.datasource);

  @override
  Future<List<Mesa>> obtenerMesas() async {
    final rows = await datasource.obtenerMesas();
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<int> crearMesa({String? nombre}) async {
    final mesas = await datasource.obtenerMesas();
    final sugerido = 'Mesa ${mesas.length + 1}';
    final nombreFinal =
        (nombre == null || nombre.trim().isEmpty) ? sugerido : nombre.trim();
    return datasource.insertarMesa(nombreFinal);
  }

  @override
  Future<void> editarMesa({required int mesaId, required String nombre}) {
    return datasource.actualizarNombreMesa(mesaId, nombre.trim());
  }

  @override
  Future<Pedido?> obtenerPedidoAbiertoPorMesa(int mesaId) async {
    final pedidoData = await datasource.obtenerPedidoAbiertoPorMesa(mesaId);
    if (pedidoData == null) return null;
    final itemsData = await datasource.obtenerItemsPedido(pedidoData.id);
    final items = itemsData.map((i) => i.toEntity()).toList();
    return Pedido(
      id: pedidoData.id,
      mesaId: pedidoData.mesaId,
      tipo: pedidoData.tipo,
      valorDomicilio: pedidoData.valorDomicilio,
      estado: pedidoData.estado,
      items: items,
      creadoEn: pedidoData.creadoEn,
    );
  }

  @override
  Future<int> crearPedido({
    required int? mesaId,
    required String tipo,
    double valorDomicilio = 0,
  }) async {
    final id = await datasource.insertarPedido(
      db.PedidosCompanion.insert(
        mesaId: Value(mesaId),
        tipo: Value(tipo),
        valorDomicilio: Value(valorDomicilio),
        creadoEn: Value(DateTime.now()),
      ),
    );
    if (mesaId != null) {
      await datasource.actualizarEstadoMesa(mesaId, 'ocupada');
    }
    return id;
  }

  @override
  Future<void> agregarItem(ItemPedido item) =>
      datasource.insertarItem(item.toCompanion());

  @override
  Future<void> editarItem(ItemPedido item) =>
      datasource.actualizarItem(item.toCompanion());

  @override
  Future<void> eliminarItem(int itemId) => datasource.eliminarItem(itemId);

  @override
  Future<void> cerrarPedido(int pedidoId) async {
    await datasource.cerrarPedido(pedidoId);
  }

  @override
  Future<List<Pedido>> obtenerPedidosDelDia() async {
    final pedidosData = await datasource.obtenerPedidosDelDia();
    final pedidos = <Pedido>[];
    for (final p in pedidosData) {
      final itemsData = await datasource.obtenerItemsPedido(p.id);
      pedidos.add(Pedido(
        id: p.id,
        mesaId: p.mesaId,
        tipo: p.tipo,
        valorDomicilio: p.valorDomicilio,
        estado: p.estado,
        items: itemsData.map((i) => i.toEntity()).toList(),
        creadoEn: p.creadoEn,
      ));
    }
    return pedidos;
  }
}
