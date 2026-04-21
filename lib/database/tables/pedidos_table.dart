import 'package:drift/drift.dart';

class Mesas extends Table {
  IntColumn get id       => integer().autoIncrement()();
  TextColumn get nombre  => text()(); // "Mesa 1", "Mesa 2"
  TextColumn get estado  => text().withDefault(const Constant('libre'))();
  // estados: libre | ocupada
}

class Pedidos extends Table {
  IntColumn get id          => integer().autoIncrement()();
  IntColumn get mesaId      => integer().nullable().references(Mesas, #id)();
  TextColumn get tipo       => text().withDefault(const Constant('mesa'))();
  // tipo: mesa | domicilio
  RealColumn get valorDomicilio => real().withDefault(const Constant(0))();
  TextColumn get estado     => text().withDefault(const Constant('abierto'))();
  // estado: abierto | cerrado | pagado
  DateTimeColumn get creadoEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get cerradoEn => dateTime().nullable()();
}

class ItemsPedido extends Table {
  IntColumn get id          => integer().autoIncrement()();
  IntColumn get pedidoId    => integer().references(Pedidos, #id)();
  IntColumn get productoId  => integer()();
  TextColumn get nombreProducto => text()();
  RealColumn get precio     => real()();
  IntColumn  get cantidad   => integer().withDefault(const Constant(1))();
  TextColumn get adicionales => text().withDefault(const Constant('[]'))();
  // JSON array de strings: ["Jugosa", "Solo cerdo"]
  TextColumn get nota       => text().withDefault(const Constant(''))();
}
