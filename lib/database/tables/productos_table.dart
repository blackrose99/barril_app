import 'package:drift/drift.dart';

class Categorias extends Table {
  IntColumn get id     => integer().autoIncrement()();
  TextColumn get nombre => text()(); // Bebidas | Picadas | Porciones
  IntColumn  get orden  => integer().withDefault(const Constant(0))();
}

class Productos extends Table {
  IntColumn  get id          => integer().autoIncrement()();
  IntColumn  get categoriaId => integer().references(Categorias, #id)();
  TextColumn get nombre      => text()();
  TextColumn get descripcion => text().withDefault(const Constant(''))();
  RealColumn get precio      => real()();
  BoolColumn get activo      => boolean().withDefault(const Constant(true))();
}

class Adicionales extends Table {
  IntColumn  get id     => integer().autoIncrement()();
  TextColumn get nombre => text()(); // "Jugosa", "Seca", "Solo cerdo"
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
}
