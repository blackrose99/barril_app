import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../database/app_database.dart';
import '../../../../injection_container.dart';

class ConfigProductosScreen extends StatefulWidget {
  const ConfigProductosScreen({super.key});

  @override
  State<ConfigProductosScreen> createState() => _ConfigProductosScreenState();
}

class _ConfigProductosScreenState extends State<ConfigProductosScreen> {
  final AppDatabase _db = sl<AppDatabase>();

  bool _loading = true;
  String _query = '';
  List<Categoria> _categorias = const [];
  List<Producto> _productos = const [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _loading = true);

    final categorias = await (_db.select(_db.categorias)
          ..orderBy([(c) => drift.OrderingTerm(expression: c.orden)]))
        .get();

    final productos = await (_db.select(_db.productos)
          ..where((p) => p.activo.equals(true))
          ..orderBy([
            (p) => drift.OrderingTerm(
                expression: p.id, mode: drift.OrderingMode.desc)
          ]))
        .get();

    if (!mounted) return;
    setState(() {
      _categorias = categorias;
      _productos = productos;
      _loading = false;
    });
  }

  Future<void> _crearProducto() async {
    if (_categorias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero crea una categoria.')),
      );
      return;
    }

    int categoriaId = _categorias.first.id;
    final nombreCtrl = TextEditingController();
    final descripcionCtrl = TextEditingController();
    final precioCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocalState) => AlertDialog(
          title: const Text('Nuevo producto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: categoriaId,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: _categorias
                      .map((c) =>
                          DropdownMenuItem(value: c.id, child: Text(c.nombre)))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setLocalState(() => categoriaId = value);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descripcionCtrl,
                  decoration: const InputDecoration(labelText: 'Descripcion'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: precioCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Precio'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Crear'),
            ),
          ],
        ),
      ),
    );

    if (ok != true) return;

    final nombre = nombreCtrl.text.trim();
    final precio = double.tryParse(precioCtrl.text.trim());
    if (nombre.isEmpty || precio == null || precio <= 0) return;

    await _db.into(_db.productos).insert(
          ProductosCompanion.insert(
            categoriaId: categoriaId,
            nombre: nombre,
            descripcion: drift.Value(descripcionCtrl.text.trim()),
            precio: precio,
          ),
        );

    await _cargar();
  }

  Future<void> _editarProducto(Producto producto) async {
    int categoriaId = producto.categoriaId;
    final nombreCtrl = TextEditingController(text: producto.nombre);
    final descripcionCtrl = TextEditingController(text: producto.descripcion);
    final precioCtrl =
        TextEditingController(text: producto.precio.toStringAsFixed(0));

    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocalState) => AlertDialog(
          title: const Text('Editar producto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: categoriaId,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: _categorias
                      .map((c) =>
                          DropdownMenuItem(value: c.id, child: Text(c.nombre)))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setLocalState(() => categoriaId = value);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descripcionCtrl,
                  decoration: const InputDecoration(labelText: 'Descripcion'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: precioCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Precio'),
                ),
              ],
            ),
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
      ),
    );

    if (ok != true) return;

    final nombre = nombreCtrl.text.trim();
    final precio = double.tryParse(precioCtrl.text.trim());
    if (nombre.isEmpty || precio == null || precio <= 0) return;

    await (_db.update(_db.productos)..where((p) => p.id.equals(producto.id)))
        .write(
      ProductosCompanion(
        categoriaId: drift.Value(categoriaId),
        nombre: drift.Value(nombre),
        descripcion: drift.Value(descripcionCtrl.text.trim()),
        precio: drift.Value(precio),
      ),
    );

    await _cargar();
  }

  Future<void> _eliminarProducto(Producto producto) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('Deseas eliminar ${producto.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    await (_db.update(_db.productos)..where((p) => p.id.equals(producto.id)))
        .write(
      const ProductosCompanion(activo: drift.Value(false)),
    );

    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    final filtrados = _productos.where((p) {
      final q = _query.trim().toLowerCase();
      if (q.isEmpty) return true;
      final cat = _categorias
          .firstWhere(
            (c) => c.id == p.categoriaId,
            orElse: () => const Categoria(id: 0, nombre: '', orden: 0),
          )
          .nombre;
      final text = '${p.nombre} ${p.descripcion} $cat'.toLowerCase();
      return text.contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Productos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _crearProducto,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo producto'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Buscar producto',
                    ),
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ),
                Expanded(
                  child: filtrados.isEmpty
                      ? const Center(child: Text('No hay productos.'))
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: filtrados.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, i) {
                            final p = filtrados[i];
                            final cat = _categorias
                                .firstWhere(
                                  (c) => c.id == p.categoriaId,
                                  orElse: () => const Categoria(
                                    id: 0,
                                    nombre: 'Sin categoria',
                                    orden: 0,
                                  ),
                                )
                                .nombre;
                            return Card(
                              child: ListTile(
                                title: Text(p.nombre),
                                subtitle:
                                    Text('$cat · ${formatMoney(p.precio)}'),
                                trailing: Wrap(
                                  spacing: 4,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined),
                                      onPressed: () => _editarProducto(p),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: AppColors.error),
                                      onPressed: () => _eliminarProducto(p),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
