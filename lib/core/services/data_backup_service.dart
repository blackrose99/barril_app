import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../database/app_database.dart';

class DataBackupService {
  final AppDatabase _db;

  DataBackupService(this._db);

  Future<File> exportToFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final file = File('${directory.path}/barril_backup_$stamp.json');
    final payload = await exportPayload();
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(payload),
    );
    return file;
  }

  Future<Map<String, dynamic>> exportPayload() async {
    final categorias = await _db.select(_db.categorias).get();
    final productos = await _db.select(_db.productos).get();
    final adicionales = await _db.select(_db.adicionales).get();
    final mesas = await _db.select(_db.mesas).get();
    final pedidos = await _db.select(_db.pedidos).get();
    final itemsPedido = await _db.select(_db.itemsPedido).get();
    final facturas = await _db.select(_db.facturas).get();
    final configuracion = await _db.select(_db.configuracion).get();

    return {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'categorias': categorias.map((row) => row.toJson()).toList(),
      'productos': productos.map((row) => row.toJson()).toList(),
      'adicionales': adicionales.map((row) => row.toJson()).toList(),
      'mesas': mesas.map((row) => row.toJson()).toList(),
      'pedidos': pedidos.map((row) => row.toJson()).toList(),
      'itemsPedido': itemsPedido.map((row) => row.toJson()).toList(),
      'facturas': facturas.map((row) => row.toJson()).toList(),
      'configuracion': configuracion.map((row) => row.toJson()).toList(),
    };
  }

  Future<void> restoreFromJson(String rawJson) async {
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('El respaldo no tiene un formato valido.');
    }

    final categorias = _readList(decoded, 'categorias')
        .map((e) => Categoria.fromJson(_readMap(e)))
        .toList();
    final productos = _readList(decoded, 'productos')
        .map((e) => Producto.fromJson(_readMap(e)))
        .toList();
    final adicionales = _readList(decoded, 'adicionales')
        .map((e) => Adicionale.fromJson(_readMap(e)))
        .toList();
    final mesas = _readList(decoded, 'mesas')
        .map((e) => Mesa.fromJson(_readMap(e)))
        .toList();
    final pedidos = _readList(decoded, 'pedidos')
        .map((e) => Pedido.fromJson(_readMap(e)))
        .toList();
    final itemsPedido = _readList(decoded, 'itemsPedido')
        .map((e) => ItemsPedidoData.fromJson(_readMap(e)))
        .toList();
    final facturas = _readList(decoded, 'facturas')
        .map((e) => Factura.fromJson(_readMap(e)))
        .toList();
    final configuracion = _readList(decoded, 'configuracion')
        .map((e) => ConfiguracionData.fromJson(_readMap(e)))
        .toList();

    await _db.transaction(() async {
      await _db.batch((batch) {
        batch.deleteAll(_db.itemsPedido);
        batch.deleteAll(_db.facturas);
        batch.deleteAll(_db.pedidos);
        batch.deleteAll(_db.productos);
        batch.deleteAll(_db.adicionales);
        batch.deleteAll(_db.mesas);
        batch.deleteAll(_db.categorias);
        batch.deleteAll(_db.configuracion);
      });

      await _db.batch((batch) {
        batch.insertAll(_db.categorias, categorias);
        batch.insertAll(_db.adicionales, adicionales);
        batch.insertAll(_db.mesas, mesas);
        batch.insertAll(_db.configuracion, configuracion);
        batch.insertAll(_db.productos, productos);
        batch.insertAll(_db.pedidos, pedidos);
        batch.insertAll(_db.itemsPedido, itemsPedido);
        batch.insertAll(_db.facturas, facturas);
      });
    });
  }

  List<dynamic> _readList(Map<String, dynamic> decoded, String key) {
    final value = decoded[key];
    if (value is List<dynamic>) return value;
    return const [];
  }

  Map<String, dynamic> _readMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    return Map<String, dynamic>.from(value as Map);
  }
}
