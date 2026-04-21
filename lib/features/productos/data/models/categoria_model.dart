import '../../../../database/app_database.dart' as db;
import '../../domain/entities/categoria.dart' as domain;

extension CategoriaModelMapper on db.Categoria {
  domain.Categoria toEntity() => domain.Categoria(
        id: id,
        nombre: nombre,
        orden: orden,
      );
}
