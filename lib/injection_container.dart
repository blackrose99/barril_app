import 'package:get_it/get_it.dart';
import 'database/app_database.dart';
import 'features/pedidos/data/datasources/pedido_local_datasource.dart';
import 'features/pedidos/data/repositories/pedido_repository_impl.dart';
import 'features/pedidos/domain/repositories/pedido_repository.dart';
import 'features/pedidos/domain/usecases/agregar_item.dart';
import 'features/pedidos/domain/usecases/cerrar_cuenta.dart';
import 'features/pedidos/domain/usecases/crear_mesa.dart';
import 'features/pedidos/domain/usecases/crear_pedido.dart';
import 'features/pedidos/domain/usecases/editar_mesa.dart';
import 'features/pedidos/domain/usecases/obtener_mesas.dart';
import 'features/pedidos/domain/usecases/obtener_pedido_abierto_por_mesa.dart';
import 'features/productos/data/datasources/producto_local_datasource.dart';
import 'features/productos/data/repositories/producto_repository_impl.dart';
import 'features/productos/domain/repositories/producto_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Base de datos
  sl.registerSingleton<AppDatabase>(AppDatabase());

  // Datasources
  sl.registerLazySingleton(() => PedidoLocalDatasource(sl()));
  sl.registerLazySingleton(() => ProductoLocalDatasource(sl()));

  // Repositorios
  sl.registerLazySingleton<PedidoRepository>(() => PedidoRepositoryImpl(sl()));
  sl.registerLazySingleton<ProductoRepository>(
      () => ProductoRepositoryImpl(sl()));

  // Casos de uso — Pedidos
  sl.registerLazySingleton(() => ObtenerMesas(sl()));
  sl.registerLazySingleton(() => CrearMesa(sl()));
  sl.registerLazySingleton(() => EditarMesa(sl()));
  sl.registerLazySingleton(() => CrearPedido(sl()));
  sl.registerLazySingleton(() => AgregarItem(sl()));
  sl.registerLazySingleton(() => CerrarCuenta(sl()));
  sl.registerLazySingleton(() => ObtenerPedidoAbiertoPorMesa(sl()));
}
