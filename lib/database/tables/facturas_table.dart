import 'package:drift/drift.dart';

class Facturas extends Table {
  IntColumn  get id           => integer().autoIncrement()();
  TextColumn get codigo       => text()(); // FAC-20250413-001
  IntColumn  get pedidoId     => integer()();
  RealColumn get subtotal     => real()();
  RealColumn get domicilio    => real().withDefault(const Constant(0))();
  RealColumn get total        => real()();
  TextColumn get estado       => text().withDefault(const Constant('pendiente'))();
  // pendiente | pagada
  DateTimeColumn get creadaEn => dateTime().withDefault(currentDateAndTime)();
}

class Configuracion extends Table {
  IntColumn  get id           => integer().autoIncrement()();
  TextColumn get clave        => text().unique()();
  TextColumn get valor        => text()();
  // Ejemplos: 'valor_domicilio' -> '5000'
  //           'total_mesas'     -> '10'
  //           'nombre_negocio'  -> 'Carne al Barril'
}
