import '../entities/producto.dart';
import '../entities/categoria.dart';
import '../entities/adicional.dart';

abstract class ProductoRepository {
  Future<List<Producto>>  obtenerProductos();
  Future<List<Producto>>  obtenerPorCategoria(int categoriaId);
  Future<List<Categoria>> obtenerCategorias();
  Future<List<Adicional>> obtenerAdicionales();
  Future<void>            crearProducto(Producto producto);
  Future<void>            editarProducto(Producto producto);
  Future<void>            eliminarProducto(int id);
}
