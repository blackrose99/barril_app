import '../../../../database/app_database.dart' as db;
import '../../domain/entities/adicional.dart' as domain;

extension AdicionalModelMapper on db.Adicionale {
  domain.Adicional toEntity() => domain.Adicional(
        id: id,
        nombre: nombre,
        activo: activo,
      );
}
