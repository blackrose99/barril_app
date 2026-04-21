import 'dart:convert';

import 'package:drift/drift.dart' show OrderingTerm, Value, Variable;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../database/app_database.dart' as dbi;
import '../../../../injection_container.dart';
import '../../../productos/domain/entities/producto.dart';
import '../../../productos/presentation/providers/productos_provider.dart';
import '../../domain/entities/item_pedido.dart';
import '../widgets/adicionales_chips.dart';
import '../widgets/cantidad_selector.dart';

String _formatMoney(num value) {
  return formatMoney(value);
}

class PedidoScreen extends ConsumerStatefulWidget {
  final int pedidoId;
  final String titulo;
  final bool esDomicilio;

  const PedidoScreen({
    super.key,
    required this.pedidoId,
    required this.titulo,
    required this.esDomicilio,
  });

  @override
  ConsumerState<PedidoScreen> createState() => _PedidoScreenState();
}

class _PedidoScreenState extends ConsumerState<PedidoScreen> {
  bool _cargando = true;
  bool _mostrarFactura = false;
  bool _mostrarSelectorProductos = true;
  int? _pedidoId;
  final dbi.AppDatabase _db = sl<dbi.AppDatabase>();
  final List<ItemPedido> _items = [];
  bool _esDomicilio = false;
  bool _cobrarDomicilio = false;
  double _valorDomicilioConfig = 5000;

  void _toggleFacturaPanel() {
    setState(() {
      if (_mostrarFactura) {
        _mostrarFactura = false;
      } else {
        _mostrarFactura = true;
        _mostrarSelectorProductos = false;
      }
    });
  }

  void _toggleProductosPanel() {
    setState(() {
      if (_mostrarSelectorProductos) {
        _mostrarSelectorProductos = false;
      } else {
        _mostrarSelectorProductos = true;
        _mostrarFactura = false;
      }
    });
  }

  void _activarBusquedaProductos() {
    setState(() {
      _mostrarSelectorProductos = true;
      _mostrarFactura = false;
    });
  }

  int _nowEpochMs() => DateTime.now().millisecondsSinceEpoch;

  String _normalizarNota(String nota) => nota.trim();

  List<String> _normalizarAdicionales(List<String> adicionales) {
    final normalizados = adicionales
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList()
      ..sort();
    return normalizados;
  }

  String _firmaItem({
    required int productoId,
    required double precio,
    required List<String> adicionales,
    required String nota,
  }) {
    final precioCentavos = (precio * 100).round();
    final adicionalesFirma = _normalizarAdicionales(adicionales).join('|');
    final notaFirma = _normalizarNota(nota);
    return '$productoId#$precioCentavos#$adicionalesFirma#$notaFirma';
  }

  Future<void> _consolidarItemsDuplicadosPedido(int pedidoId) async {
    final rows = await (_db.select(_db.itemsPedido)
          ..where((i) => i.pedidoId.equals(pedidoId))
          ..orderBy([(i) => OrderingTerm.asc(i.id)]))
        .get();

    final porFirma = <String, List<dbi.ItemsPedidoData>>{};
    for (final row in rows) {
      List<String> adicionales = const [];
      try {
        final decoded = jsonDecode(row.adicionales);
        if (decoded is List) {
          adicionales = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {
        adicionales = const [];
      }

      final firma = _firmaItem(
        productoId: row.productoId,
        precio: row.precio,
        adicionales: adicionales,
        nota: row.nota,
      );
      porFirma.putIfAbsent(firma, () => []).add(row);
    }

    final hayDuplicados = porFirma.values.any((grupo) => grupo.length > 1);
    if (!hayDuplicados) return;

    await _db.transaction(() async {
      for (final grupo in porFirma.values) {
        if (grupo.length <= 1) continue;

        final base = grupo.first;
        final cantidadTotal =
            grupo.fold<int>(0, (sum, item) => sum + item.cantidad);

        await (_db.update(_db.itemsPedido)..where((i) => i.id.equals(base.id)))
            .write(dbi.ItemsPedidoCompanion(cantidad: Value(cantidadTotal)));

        final idsEliminar = grupo.skip(1).map((e) => e.id).toList();
        for (final id in idsEliminar) {
          await (_db.delete(_db.itemsPedido)..where((i) => i.id.equals(id)))
              .go();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    await _normalizarFechasPedidos();
    await _consolidarItemsDuplicadosPedido(widget.pedidoId);

    final pedidoRow = await _db.customSelect(
      '''
      SELECT tipo, valor_domicilio
      FROM pedidos
      WHERE id = ?
      LIMIT 1
      ''',
      variables: [Variable<int>(widget.pedidoId)],
    ).getSingle();
    final pedidoData = pedidoRow.data;

    final valorDomicilioConf = await (_db.select(_db.configuracion)
          ..where((c) => c.clave.equals('valor_domicilio')))
        .getSingleOrNull();
    final configParsed =
        double.tryParse(valorDomicilioConf?.valor ?? '5000') ?? 5000;

    final rows = await (_db.select(_db.itemsPedido)
          ..where((i) => i.pedidoId.equals(widget.pedidoId)))
        .get();

    if (!mounted) return;

    setState(() {
      _pedidoId = widget.pedidoId;
      _valorDomicilioConfig = configParsed;
      _esDomicilio = (pedidoData['tipo'] as String?) == 'domicilio';
      _cobrarDomicilio =
          _esDomicilio && ((pedidoData['valor_domicilio'] as num?) ?? 0) > 0;
      _items
        ..clear()
        ..addAll(
          rows.map(
            (item) => ItemPedido(
              id: item.id,
              pedidoId: item.pedidoId,
              productoId: item.productoId,
              nombreProducto: item.nombreProducto,
              precio: item.precio,
              cantidad: item.cantidad,
              adicionales: List<String>.from(
                jsonDecode(item.adicionales) as List<dynamic>,
              ),
              nota: item.nota,
            ),
          ),
        );
      _cargando = false;
    });
  }

  Future<void> _normalizarFechasPedidos() async {
    await _db.customStatement('''
      UPDATE pedidos
      SET creado_en = CAST(strftime('%s', creado_en) AS INTEGER) * 1000
      WHERE creado_en IS NOT NULL
        AND typeof(creado_en) = 'text'
        AND TRIM(creado_en) != ''
    ''');

    await _db.customStatement('''
      UPDATE pedidos
      SET cerrado_en = CAST(strftime('%s', cerrado_en) AS INTEGER) * 1000
      WHERE cerrado_en IS NOT NULL
        AND typeof(cerrado_en) = 'text'
        AND TRIM(cerrado_en) != ''
    ''');
  }

  Future<void> _actualizarModoDomicilio() async {
    if (_pedidoId == null) return;
    final tipo = _esDomicilio ? 'domicilio' : 'mesa';
    final valor =
        _esDomicilio ? (_cobrarDomicilio ? _valorDomicilioConfig : 0.0) : 0.0;

    await (_db.update(_db.pedidos)..where((p) => p.id.equals(_pedidoId!)))
        .write(
      dbi.PedidosCompanion(
        tipo: Value(tipo),
        valorDomicilio: Value(valor),
      ),
    );
  }

  Future<String> _leerConfig(String clave, {String fallback = ''}) async {
    final row = await (_db.select(_db.configuracion)
          ..where((c) => c.clave.equals(clave)))
        .getSingleOrNull();
    return row?.valor ?? fallback;
  }

  Future<List<String>> _impresorasConfiguradas() async {
    final raw = await _leerConfig('printer_devices', fallback: 'POS principal');
    return raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> _actualizarEstadoPedido(String estado) async {
    if (_pedidoId == null) return;
    final cerradoEn = estado == 'abierto' ? null : _nowEpochMs();
    await _db.customStatement(
      'UPDATE pedidos SET estado = ?, cerrado_en = ? WHERE id = ?',
      [estado, cerradoEn, _pedidoId!],
    );
  }

  Future<void> _cerrarPedidoDesdeDetalle() async {
    if (_pedidoId == null) return;

    if (_items.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega productos antes de cerrar.')),
      );
      return;
    }

    final impresoras = await _impresorasConfiguradas();
    if (!mounted) return;

    if (impresoras.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('No hay impresoras configuradas. Configuralas primero.'),
        ),
      );
      return;
    }

    final impresoraDefault =
        await _leerConfig('printer_default', fallback: impresoras.first);
    String impresoraSeleccionada = impresoras.contains(impresoraDefault)
        ? impresoraDefault
        : impresoras.first;

    if (!mounted) return;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocalState) => AlertDialog(
          title: const Text('Cerrar pedido e imprimir POS'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Selecciona la impresora para imprimir el POS:'),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: impresoraSeleccionada,
                items: impresoras
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setLocalState(() => impresoraSeleccionada = value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Cerrar e imprimir'),
            ),
          ],
        ),
      ),
    );

    if (confirmar != true) return;

    await _db.customStatement(
      "UPDATE configuracion SET valor = ? WHERE clave = 'printer_default'",
      [impresoraSeleccionada],
    );
    await _actualizarEstadoPedido('cerrado');

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Pedido cerrado. POS enviado a $impresoraSeleccionada.')),
    );
    Navigator.pop(context, true);
  }

  Future<void> _cancelarPedidoDesdeDetalle() async {
    if (_pedidoId == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar cancelacion'),
        content: Text(
          _items.isNotEmpty
              ? 'Este pedido tiene ${_items.length} item(s). Estas segura de cancelarlo?'
              : 'Estas segura de cancelar este pedido?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Si, cancelar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    await _actualizarEstadoPedido('cancelado');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pedido cancelado.')),
    );
    Navigator.pop(context, true);
  }

  Future<void> _cambiarEnvioDomicilio(bool value) async {
    setState(() {
      _esDomicilio = value;
      _cobrarDomicilio = value ? _cobrarDomicilio : false;
      if (value && !_cobrarDomicilio) {
        _cobrarDomicilio = true;
      }
    });
    await _actualizarModoDomicilio();
  }

  Future<void> _cambiarCobroDomicilio(bool value) async {
    if (!_esDomicilio) return;
    setState(() => _cobrarDomicilio = value);
    await _actualizarModoDomicilio();
  }

  Future<void> _mostrarModalDomicilio() async {
    if (_pedidoId == null) return;

    bool esDomicilioLocal = _esDomicilio;
    bool cobrarDomicilioLocal = _cobrarDomicilio;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setLocalState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Configuracion de domicilio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ajusta aqui si el pedido es domicilio y si se cobra envio.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Enviar a domicilio'),
                  value: esDomicilioLocal,
                  onChanged: (value) {
                    setLocalState(() {
                      esDomicilioLocal = value;
                      if (!value) {
                        cobrarDomicilioLocal = false;
                      } else if (!cobrarDomicilioLocal) {
                        cobrarDomicilioLocal = true;
                      }
                    });
                  },
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Cobrar domicilio'),
                  subtitle: Text(_formatMoney(_valorDomicilioConfig)),
                  value: esDomicilioLocal && cobrarDomicilioLocal,
                  onChanged: esDomicilioLocal
                      ? (value) {
                          setLocalState(() => cobrarDomicilioLocal = value);
                        }
                      : null,
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () async {
                    final cambioDomicilio = esDomicilioLocal != _esDomicilio;
                    final cambioCobro =
                        cobrarDomicilioLocal != _cobrarDomicilio;

                    if (cambioDomicilio) {
                      await _cambiarEnvioDomicilio(esDomicilioLocal);
                    }
                    if (!cambioDomicilio && cambioCobro) {
                      await _cambiarCobroDomicilio(cobrarDomicilioLocal);
                    } else if (cambioDomicilio && esDomicilioLocal) {
                      await _cambiarCobroDomicilio(cobrarDomicilioLocal);
                    }

                    if (!sheetContext.mounted) return;
                    Navigator.of(sheetContext).pop();
                  },
                  child: const Text('Guardar cambios'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _agregarProducto(Producto producto, int cantidad,
      List<String> adicionales, String nota) async {
    if (_pedidoId == null) return;

    final adicionalesNorm = _normalizarAdicionales(adicionales);
    final notaNorm = _normalizarNota(nota);
    final firmaNuevo = _firmaItem(
      productoId: producto.id,
      precio: producto.precio,
      adicionales: adicionalesNorm,
      nota: notaNorm,
    );

    final indexExistente = _items.indexWhere(
      (item) =>
          _firmaItem(
            productoId: item.productoId,
            precio: item.precio,
            adicionales: item.adicionales,
            nota: item.nota,
          ) ==
          firmaNuevo,
    );

    if (indexExistente != -1) {
      final itemExistente = _items[indexExistente];
      final nuevaCantidad = itemExistente.cantidad + cantidad;

      await (_db.update(_db.itemsPedido)
            ..where((i) => i.id.equals(itemExistente.id)))
          .write(dbi.ItemsPedidoCompanion(cantidad: Value(nuevaCantidad)));

      if (!mounted) return;
      setState(() {
        _items[indexExistente] = ItemPedido(
          id: itemExistente.id,
          pedidoId: itemExistente.pedidoId,
          productoId: itemExistente.productoId,
          nombreProducto: itemExistente.nombreProducto,
          precio: itemExistente.precio,
          cantidad: nuevaCantidad,
          adicionales: itemExistente.adicionales,
          nota: itemExistente.nota,
        );
      });
      return;
    }

    final itemId = await _db.into(_db.itemsPedido).insert(
          dbi.ItemsPedidoCompanion.insert(
            pedidoId: _pedidoId!,
            productoId: producto.id,
            nombreProducto: producto.nombre,
            precio: producto.precio,
            cantidad: Value(cantidad),
            adicionales: Value(jsonEncode(adicionalesNorm)),
            nota: Value(notaNorm),
          ),
        );

    final item = ItemPedido(
      id: itemId,
      pedidoId: _pedidoId!,
      productoId: producto.id,
      nombreProducto: producto.nombre,
      precio: producto.precio,
      cantidad: cantidad,
      adicionales: adicionalesNorm,
      nota: notaNorm,
    );
    setState(() => _items.add(item));
  }

  Future<void> _editarItem(ItemPedido item) async {
    final cantidadCtrl = TextEditingController(text: item.cantidad.toString());

    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Editar ${item.nombreProducto}'),
        content: TextField(
          controller: cantidadCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Cantidad'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (ok != true) return;
    final nuevaCantidad = int.tryParse(cantidadCtrl.text.trim());
    if (nuevaCantidad == null || nuevaCantidad <= 0) return;

    await (_db.update(_db.itemsPedido)..where((i) => i.id.equals(item.id)))
        .write(
      dbi.ItemsPedidoCompanion(cantidad: Value(nuevaCantidad)),
    );

    if (!mounted) return;
    setState(() {
      final idx = _items.indexWhere((e) => e.id == item.id);
      if (idx == -1) return;
      _items[idx] = ItemPedido(
        id: item.id,
        pedidoId: item.pedidoId,
        productoId: item.productoId,
        nombreProducto: item.nombreProducto,
        precio: item.precio,
        cantidad: nuevaCantidad,
        adicionales: item.adicionales,
        nota: item.nota,
      );
    });
  }

  Future<void> _eliminarItem(ItemPedido item) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('Deseas eliminar ${item.nombreProducto} del pedido?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    await (_db.delete(_db.itemsPedido)..where((i) => i.id.equals(item.id)))
        .go();
    if (!mounted) return;
    setState(() => _items.removeWhere((e) => e.id == item.id));
  }

  @override
  Widget build(BuildContext context) {
    final titulo = widget.titulo;
    final separacionPaneles = _items.length <= 1 ? 4.0 : 8.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(titulo,
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'cerrar') {
                _cerrarPedidoDesdeDetalle();
              } else if (value == 'cancelar') {
                _cancelarPedidoDesdeDetalle();
              } else if (value == 'domicilio') {
                _mostrarModalDomicilio();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'domicilio',
                child: Text('Domicilio'),
              ),
              PopupMenuItem<String>(
                value: 'cerrar',
                child: Text('Cerrar pedido'),
              ),
              PopupMenuItem<String>(
                value: 'cancelar',
                child: Text('Cancelar pedido'),
              ),
            ],
          ),
        ],
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent))
          : SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  if (_mostrarFactura)
                    Expanded(
                      child: _FacturaPanel(
                        expandido: true,
                        onToggleExpandido: _toggleFacturaPanel,
                        titulo: titulo,
                        esDomicilio: _esDomicilio,
                        cobrarDomicilio: _cobrarDomicilio,
                        valorDomicilio: _valorDomicilioConfig,
                        items: _items,
                        onEditar: _editarItem,
                        onEliminar: _eliminarItem,
                      ),
                    )
                  else
                    _FacturaPanel(
                      expandido: false,
                      onToggleExpandido: _toggleFacturaPanel,
                      titulo: titulo,
                      esDomicilio: _esDomicilio,
                      cobrarDomicilio: _cobrarDomicilio,
                      valorDomicilio: _valorDomicilioConfig,
                      items: _items,
                      onEditar: _editarItem,
                      onEliminar: _eliminarItem,
                    ),
                  SizedBox(height: separacionPaneles),
                  if (_mostrarSelectorProductos)
                    Expanded(
                      child: _CuerpoProductos(
                        expandido: true,
                        onToggleExpandido: _toggleProductosPanel,
                        items: _items,
                        onAgregar: _agregarProducto,
                        onBuscarProducto: _activarBusquedaProductos,
                      ),
                    )
                  else
                    _CuerpoProductos(
                      expandido: false,
                      onToggleExpandido: _toggleProductosPanel,
                      items: _items,
                      onAgregar: _agregarProducto,
                      onBuscarProducto: _activarBusquedaProductos,
                    ),
                ],
              ),
            ),
    );
  }
}

class _CuerpoProductos extends ConsumerStatefulWidget {
  final bool expandido;
  final VoidCallback onToggleExpandido;
  final List<ItemPedido> items;
  final void Function(Producto, int, List<String>, String) onAgregar;
  final VoidCallback onBuscarProducto;

  const _CuerpoProductos({
    required this.expandido,
    required this.onToggleExpandido,
    required this.items,
    required this.onAgregar,
    required this.onBuscarProducto,
  });

  @override
  ConsumerState<_CuerpoProductos> createState() => _CuerpoProductosState();
}

class _CuerpoProductosState extends ConsumerState<_CuerpoProductos> {
  String _query = '';
  int? _productoExpandidoId;
  final dbi.AppDatabase _db = sl<dbi.AppDatabase>();
  Map<int, List<String>> _etiquetasPorCategoria = const {};

  @override
  void initState() {
    super.initState();
    _cargarEtiquetasPorCategoria();
  }

  Future<void> _cargarEtiquetasPorCategoria() async {
    await _db.customStatement('''
      CREATE TABLE IF NOT EXISTS categoria_etiquetas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categoria_id INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        activa INTEGER NOT NULL DEFAULT 1
      )
    ''');

    final rows = await _db.customSelect(
      '''
      SELECT categoria_id, nombre
      FROM categoria_etiquetas
      WHERE activa = 1
      ORDER BY id ASC
      ''',
    ).get();

    final map = <int, List<String>>{};
    for (final row in rows) {
      final data = row.data;
      final categoriaId = (data['categoria_id'] as int?) ?? 0;
      final nombre = ((data['nombre'] as String?) ?? '').trim();
      if (categoriaId <= 0 || nombre.isEmpty) continue;
      map.putIfAbsent(categoriaId, () => []).add(nombre);
    }

    if (!mounted) return;
    setState(() => _etiquetasPorCategoria = map);
  }

  @override
  Widget build(BuildContext context) {
    final categoriasAsync = ref.watch(categoriasProvider);
    final catSelec = ref.watch(categoriaSeleccionadaProvider);

    if (!widget.expandido) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: InkWell(
            onTap: widget.onToggleExpandido,
            borderRadius: BorderRadius.circular(8),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    'Productos colapsado',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  Icons.expand_more,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: InkWell(
              onTap: widget.onToggleExpandido,
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Productos',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    widget.expandido ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          ...[
            const SizedBox(height: 8),
            // Tabs de categorías
            categoriasAsync.when(
              loading: () => const SizedBox(),
              error: (e, _) => const SizedBox(),
              data: (cats) => SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: cats.map((c) {
                    final sel = catSelec == c.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(c.nombre),
                        selected: sel,
                        onSelected: (_) => ref
                            .read(categoriaSeleccionadaProvider.notifier)
                            .state = sel ? null : c.id,
                        selectedColor: AppColors.accent,
                        labelStyle: TextStyle(
                          color: sel ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        backgroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        side: BorderSide.none,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Filtrar productos por nombre',
                ),
                onTap: widget.onBuscarProducto,
                onChanged: (value) {
                  widget.onBuscarProducto();
                  setState(() => _query = value);
                },
              ),
            ),
            const SizedBox(height: 8),
            // Lista de productos
            Expanded(
              child: _ProductosLista(
                categoriaId: catSelec,
                onAgregar: widget.onAgregar,
                query: _query,
                productoExpandidoId: _productoExpandidoId,
                onCambiarExpandido: (productoId) {
                  setState(() {
                    _productoExpandidoId =
                        _productoExpandidoId == productoId ? null : productoId;
                  });
                },
                etiquetasPorCategoria: _etiquetasPorCategoria,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProductosLista extends ConsumerWidget {
  final int? categoriaId;
  final void Function(Producto, int, List<String>, String) onAgregar;
  final String query;
  final int? productoExpandidoId;
  final void Function(int productoId) onCambiarExpandido;
  final Map<int, List<String>> etiquetasPorCategoria;

  const _ProductosLista({
    required this.categoriaId,
    required this.onAgregar,
    required this.query,
    required this.productoExpandidoId,
    required this.onCambiarExpandido,
    required this.etiquetasPorCategoria,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productosAsync = categoriaId != null
        ? ref.watch(productosPorCategoriaProvider(categoriaId!))
        : ref.watch(productosProvider);

    return productosAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent)),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (productos) {
        final q = query.trim().toLowerCase();
        final filtrados = q.isEmpty
            ? productos
            : productos
                .where((p) => p.nombre.toLowerCase().contains(q))
                .toList();

        return filtrados.isEmpty
            ? const Center(
                child: Text('Sin productos',
                    style: TextStyle(color: AppColors.textMuted)))
            : ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filtrados.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final producto = filtrados[i];
                  final expandido = productoExpandidoId == producto.id;
                  return _ProductoTile(
                    producto: producto,
                    expandido: expandido,
                    onToggleExpandido: () => onCambiarExpandido(producto.id),
                    onAgregar: onAgregar,
                    etiquetasPersonalizadas:
                        etiquetasPorCategoria[producto.categoria.id] ??
                            const [],
                  );
                },
              );
      },
    );
  }
}

class _ProductoTile extends ConsumerStatefulWidget {
  final Producto producto;
  final bool expandido;
  final VoidCallback onToggleExpandido;
  final void Function(Producto, int, List<String>, String) onAgregar;
  final List<String> etiquetasPersonalizadas;

  const _ProductoTile({
    required this.producto,
    required this.expandido,
    required this.onToggleExpandido,
    required this.onAgregar,
    required this.etiquetasPersonalizadas,
  });

  @override
  ConsumerState<_ProductoTile> createState() => _ProductoTileState();
}

class _ProductoTileState extends ConsumerState<_ProductoTile> {
  int _cantidad = 1;
  List<String> _adicionales = [];
  final TextEditingController _notaCtrl = TextEditingController();

  @override
  void didUpdateWidget(covariant _ProductoTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expandido && !widget.expandido) {
      _cantidad = 1;
      _adicionales = [];
      _notaCtrl.clear();
    }
  }

  @override
  void dispose() {
    _notaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.expandido
              ? AppColors.accent.withValues(alpha: 0.4)
              : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          // Fila principal
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: widget.onToggleExpandido,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.producto.nombre,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary)),
                        if (widget.producto.descripcion.isNotEmpty)
                          Text(widget.producto.descripcion,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Text(
                    _formatMoney(widget.producto.precio),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    widget.expandido
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          // Panel expandido: adicionales + cantidad + botón agregar
          if (widget.expandido) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  if (widget.etiquetasPersonalizadas.isNotEmpty)
                    AdicionalesChips(
                      adicionales: widget.etiquetasPersonalizadas,
                      seleccionados: _adicionales,
                      onToggle: (nombre) => setState(() {
                        _adicionales.contains(nombre)
                            ? _adicionales.remove(nombre)
                            : _adicionales.add(nombre);
                      }),
                    ),
                  if (widget.etiquetasPersonalizadas.isNotEmpty)
                    const SizedBox(height: 14),
                  TextField(
                    controller: _notaCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nota del mesero (opcional)',
                      hintText: 'Ej: Sin cebolla, termino 3/4, extra salsa',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CantidadSelector(
                        cantidad: _cantidad,
                        onIncrementar: () => setState(() => _cantidad++),
                        onDecrementar: () => setState(() => _cantidad--),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          widget.onAgregar(widget.producto, _cantidad,
                              _adicionales, _notaCtrl.text.trim());
                          setState(() {
                            _cantidad = 1;
                            _adicionales = [];
                            _notaCtrl.clear();
                          });
                          widget.onToggleExpandido();
                        },
                        child: const Text('Agregar',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FacturaPanel extends StatefulWidget {
  final bool expandido;
  final VoidCallback onToggleExpandido;
  final String titulo;
  final bool esDomicilio;
  final bool cobrarDomicilio;
  final double valorDomicilio;
  final List<ItemPedido> items;
  final Future<void> Function(ItemPedido item) onEditar;
  final Future<void> Function(ItemPedido item) onEliminar;

  const _FacturaPanel({
    required this.expandido,
    required this.onToggleExpandido,
    required this.titulo,
    required this.esDomicilio,
    required this.cobrarDomicilio,
    required this.valorDomicilio,
    required this.items,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  State<_FacturaPanel> createState() => _FacturaPanelState();
}

class _FacturaPanelState extends State<_FacturaPanel> {
  int? _detalleExpandidoId;

  double get _subtotal => widget.items.fold(0, (s, i) => s + i.subtotal);
  double get _domicilio =>
      widget.esDomicilio && widget.cobrarDomicilio ? widget.valorDomicilio : 0;
  double get _total => _subtotal + _domicilio;

  void _alternarDetalle(ItemPedido item) {
    setState(() {
      _detalleExpandidoId = _detalleExpandidoId == item.id ? null : item.id;
    });
  }

  Widget _buildItemCard(ItemPedido item) {
    final etiquetas = item.adicionales;
    final expandido = _detalleExpandidoId == item.id;

    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _alternarDetalle(item),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.nombreProducto,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${item.cantidad} x ${_formatMoney(item.precio)}',
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatMoney(item.subtotal),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Icon(
                        expandido ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (etiquetas.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: etiquetas
                              .map(
                                (etiqueta) => Chip(
                                  label: Text(etiqueta),
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    if (etiquetas.isNotEmpty) const SizedBox(height: 10),
                    if (item.nota.trim().isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Nota: ${item.nota}',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    if (item.nota.trim().isNotEmpty) const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Cantidad: ${item.cantidad}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => widget.onEditar(item),
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Editar'),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () => widget.onEliminar(item),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                          ),
                          label: const Text(
                            'Eliminar',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              crossFadeState: expandido
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 180),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: InkWell(
              onTap: widget.onToggleExpandido,
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Factura - ${widget.titulo}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    widget.expandido ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          if (!widget.expandido)
            const SizedBox.shrink()
          else if (widget.items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Aun no hay productos en el pedido.',
                style: TextStyle(color: AppColors.textMuted),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                itemCount: widget.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, index) => _buildItemCard(widget.items[index]),
              ),
            ),
          if (widget.expandido)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text('Subtotal: ${_formatMoney(_subtotal)}'),
                      const SizedBox(width: 12),
                      if (widget.esDomicilio)
                        Text('Domicilio: ${_formatMoney(_domicilio)}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Total pedido',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatMoney(_total),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
