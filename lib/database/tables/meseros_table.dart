import 'package:drift/drift.dart';

class Meseros extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
}
