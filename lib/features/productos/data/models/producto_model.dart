import 'package:drift/drift.dart';
import '../../../../database/app_database.dart' as db;
import '../../domain/entities/categoria.dart';
import '../../domain/entities/producto.dart';

extension ProductoModelMapper on db.Producto {
  Producto toEntity(Categoria categoria) => Producto(
        id: id,
        categoria: categoria,
        nombre: nombre,
        descripcion: descripcion,
        precio: precio,
        activo: activo,
      );
}

extension ProductoEntityMapper on Producto {
  db.ProductosCompanion toCompanion() => db.ProductosCompanion.insert(
        categoriaId: categoria.id,
        nombre: nombre,
        descripcion: Value(descripcion),
        precio: precio,
        activo: Value(activo),
      );
}
