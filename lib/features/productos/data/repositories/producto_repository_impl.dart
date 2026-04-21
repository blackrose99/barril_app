import '../../domain/entities/adicional.dart';
import '../../domain/entities/categoria.dart';
import '../../domain/entities/producto.dart';
import '../../domain/repositories/producto_repository.dart';
import '../datasources/producto_local_datasource.dart';
import '../models/adicional_model.dart';
import '../models/categoria_model.dart';
import '../models/producto_model.dart';

class ProductoRepositoryImpl implements ProductoRepository {
  final ProductoLocalDatasource datasource;
  ProductoRepositoryImpl(this.datasource);

  @override
  Future<List<Categoria>> obtenerCategorias() async {
    final rows = await datasource.obtenerCategorias();
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<List<Producto>> obtenerProductos() async {
    final cats = await obtenerCategorias();
    final catMap = {for (final c in cats) c.id: c};
    final rows = await datasource.obtenerProductos();
    return rows
        .where((r) => catMap.containsKey(r.categoriaId))
        .map((r) => r.toEntity(catMap[r.categoriaId]!))
        .toList();
  }

  @override
  Future<List<Producto>> obtenerPorCategoria(int categoriaId) async {
    final cats = await obtenerCategorias();
    final cat = cats.firstWhere((c) => c.id == categoriaId);
    final rows = await datasource.obtenerPorCategoria(categoriaId);
    return rows.map((r) => r.toEntity(cat)).toList();
  }

  @override
  Future<List<Adicional>> obtenerAdicionales() async {
    final rows = await datasource.obtenerAdicionales();
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<void> crearProducto(Producto producto) =>
      datasource.insertarProducto(producto.toCompanion());

  @override
  Future<void> editarProducto(Producto producto) =>
      datasource.actualizarProducto(producto.toCompanion());

  @override
  Future<void> eliminarProducto(int id) =>
      datasource.eliminarProducto(id);
}
