import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/adicional.dart';
import '../../domain/entities/categoria.dart';
import '../../domain/entities/producto.dart';
import '../../domain/repositories/producto_repository.dart';
import '../../../../injection_container.dart';

final categoriasProvider = FutureProvider<List<Categoria>>((ref) =>
    sl<ProductoRepository>().obtenerCategorias());

final productosProvider = FutureProvider<List<Producto>>((ref) =>
    sl<ProductoRepository>().obtenerProductos());

final productosPorCategoriaProvider =
    FutureProvider.family<List<Producto>, int>((ref, catId) =>
        sl<ProductoRepository>().obtenerPorCategoria(catId));

final adicionalesProvider = FutureProvider<List<Adicional>>((ref) =>
    sl<ProductoRepository>().obtenerAdicionales());

// Categoría seleccionada en el selector de productos
final categoriaSeleccionadaProvider = StateProvider<int?>((ref) => null);
