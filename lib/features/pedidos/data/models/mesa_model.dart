import 'package:drift/drift.dart';
import '../../../../database/app_database.dart' as db;
import '../../domain/entities/mesa.dart' as domain;

extension MesaModelMapper on db.Mesa {
  domain.Mesa toEntity() => domain.Mesa(
        id: id,
        nombre: nombre,
        estado: estado,
      );
}

extension MesaEntityMapper on domain.Mesa {
  db.MesasCompanion toCompanion() => db.MesasCompanion.insert(
        nombre: nombre,
        estado: Value(estado),
      );
}
