import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../database/app_database.dart' as db;
import '../../domain/entities/item_pedido.dart' as domain;

extension ItemPedidoModelMapper on db.ItemsPedidoData {
  domain.ItemPedido toEntity() => domain.ItemPedido(
        id: id,
        pedidoId: pedidoId,
        productoId: productoId,
        nombreProducto: nombreProducto,
        precio: precio,
        cantidad: cantidad,
        adicionales: List<String>.from(jsonDecode(adicionales)),
        nota: nota,
      );
}

extension ItemPedidoEntityMapper on domain.ItemPedido {
  db.ItemsPedidoCompanion toCompanion() => db.ItemsPedidoCompanion.insert(
        pedidoId: pedidoId,
        productoId: productoId,
        nombreProducto: nombreProducto,
        precio: precio,
        cantidad: Value(cantidad),
        adicionales: Value(jsonEncode(adicionales)),
        nota: Value(nota),
      );
}
