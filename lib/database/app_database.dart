import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/pedidos_table.dart';
import 'tables/productos_table.dart';
import 'tables/facturas_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Mesas,
  Pedidos,
  ItemsPedido,
  Categorias,
  Productos,
  Adicionales,
  Facturas,
  Configuracion,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _insertDatosIniciales();
        },
      );

  Future<void> _insertDatosIniciales() async {
    // Categorías base
    await batch((b) {
      b.insertAll(categorias, [
        CategoriasCompanion.insert(nombre: 'Picadas', orden: const Value(1)),
        CategoriasCompanion.insert(nombre: 'Porciones', orden: const Value(2)),
        CategoriasCompanion.insert(nombre: 'Bebidas', orden: const Value(3)),
      ]);
    });

    // Adicionales base
    await batch((b) {
      b.insertAll(adicionales, [
        AdicionalesCompanion.insert(nombre: 'Jugosa'),
        AdicionalesCompanion.insert(nombre: 'Seca'),
        AdicionalesCompanion.insert(nombre: 'Chicharrón crocante'),
        AdicionalesCompanion.insert(nombre: 'Solo cerdo'),
        AdicionalesCompanion.insert(nombre: 'Solo res'),
        AdicionalesCompanion.insert(nombre: 'Sin guacamole'),
      ]);
    });

    // Configuración inicial
    await batch((b) {
      b.insertAll(configuracion, [
        ConfiguracionCompanion.insert(clave: 'valor_domicilio', valor: '5000'),
        ConfiguracionCompanion.insert(clave: 'total_mesas', valor: '6'),
        ConfiguracionCompanion.insert(
            clave: 'nombre_negocio', valor: 'Carne al Barril'),
      ]);
    });

    // Mesas iniciales (6 mesas)
    await batch((b) {
      b.insertAll(mesas, [
        for (int i = 1; i <= 6; i++) MesasCompanion.insert(nombre: 'Mesa $i'),
      ]);
    });
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'barril_app');
  }
}
