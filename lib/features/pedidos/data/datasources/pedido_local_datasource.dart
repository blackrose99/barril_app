import 'package:drift/drift.dart';
import '../../../../database/app_database.dart' as dbi;

class PedidoLocalDatasource {
  final dbi.AppDatabase db;
  PedidoLocalDatasource(this.db);

  Future<List<dbi.Mesa>> obtenerMesas() =>
      (db.select(db.mesas)..orderBy([(m) => OrderingTerm.asc(m.id)])).get();

  Future<int> insertarMesa(String nombre) =>
      db.into(db.mesas).insert(dbi.MesasCompanion.insert(nombre: nombre));

  Future<void> actualizarNombreMesa(int mesaId, String nombre) =>
      (db.update(db.mesas)..where((m) => m.id.equals(mesaId)))
          .write(dbi.MesasCompanion(nombre: Value(nombre)));

  Future<void> actualizarEstadoMesa(int mesaId, String estado) =>
      (db.update(db.mesas)..where((m) => m.id.equals(mesaId)))
          .write(dbi.MesasCompanion(estado: Value(estado)));

  Future<dbi.Pedido?> obtenerPedidoAbiertoPorMesa(int mesaId) => (db
          .select(db.pedidos)
        ..where((p) => p.mesaId.equals(mesaId) & p.estado.equals('abierto')))
      .getSingleOrNull();

  Future<int> insertarPedido(dbi.PedidosCompanion companion) =>
      db.into(db.pedidos).insert(companion);

  Future<List<dbi.ItemsPedidoData>> obtenerItemsPedido(int pedidoId) =>
      (db.select(db.itemsPedido)..where((i) => i.pedidoId.equals(pedidoId)))
          .get();

  Future<int> insertarItem(dbi.ItemsPedidoCompanion companion) =>
      db.into(db.itemsPedido).insert(companion);

  Future<void> actualizarItem(dbi.ItemsPedidoCompanion companion) =>
      db.update(db.itemsPedido).replace(companion);

  Future<void> eliminarItem(int itemId) =>
      (db.delete(db.itemsPedido)..where((i) => i.id.equals(itemId))).go();

  Future<void> cerrarPedido(int pedidoId) =>
      (db.update(db.pedidos)..where((p) => p.id.equals(pedidoId)))
          .write(dbi.PedidosCompanion(
        estado: const Value('cerrado'),
        cerradoEn: Value(DateTime.now()),
      ));

  Future<List<dbi.Pedido>> obtenerPedidosDelDia() {
    final hoy = DateTime.now();
    final inicio = DateTime(hoy.year, hoy.month, hoy.day);
    final fin = inicio.add(const Duration(days: 1));
    return (db.select(db.pedidos)
          ..where((p) =>
              p.creadoEn.isBiggerOrEqualValue(inicio) &
              p.creadoEn.isSmallerThanValue(fin)))
        .get();
  }
}
