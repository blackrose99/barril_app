import 'package:drift/drift.dart';
import '../../../../database/app_database.dart' as dbi;

class ProductoLocalDatasource {
  final dbi.AppDatabase db;
  ProductoLocalDatasource(this.db);

  Future<List<dbi.Categoria>> obtenerCategorias() => (db.select(db.categorias)
        ..orderBy([(c) => OrderingTerm(expression: c.orden)]))
      .get();

  Future<List<dbi.Producto>> obtenerProductos() =>
      (db.select(db.productos)..where((p) => p.activo.equals(true))).get();

  Future<List<dbi.Producto>> obtenerPorCategoria(int categoriaId) => (db
          .select(db.productos)
        ..where(
            (p) => p.categoriaId.equals(categoriaId) & p.activo.equals(true)))
      .get();

  Future<List<dbi.Adicionale>> obtenerAdicionales() =>
      (db.select(db.adicionales)..where((a) => a.activo.equals(true))).get();

  Future<int> insertarProducto(dbi.ProductosCompanion companion) =>
      db.into(db.productos).insert(companion);

  Future<void> actualizarProducto(dbi.ProductosCompanion companion) =>
      db.update(db.productos).replace(companion);

  Future<void> eliminarProducto(int id) =>
      (db.update(db.productos)..where((p) => p.id.equals(id)))
          .write(const dbi.ProductosCompanion(activo: Value(false)));
}
