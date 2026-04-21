import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../database/app_database.dart';
import '../../../../injection_container.dart';

class ConfigCategoriasScreen extends StatefulWidget {
  const ConfigCategoriasScreen({super.key});

  @override
  State<ConfigCategoriasScreen> createState() => _ConfigCategoriasScreenState();
}

class _ConfigCategoriasScreenState extends State<ConfigCategoriasScreen> {
  final AppDatabase _db = sl<AppDatabase>();

  bool _loading = true;
  List<Categoria> _categorias = const [];
  Map<int, List<String>> _etiquetas = const {};

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _asegurarTablaEtiquetas() async {
    await _db.customStatement('''
      CREATE TABLE IF NOT EXISTS categoria_etiquetas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categoria_id INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        activa INTEGER NOT NULL DEFAULT 1
      )
    ''');
  }

  Future<void> _cargar() async {
    setState(() => _loading = true);
    await _asegurarTablaEtiquetas();

    final categorias = await (_db.select(_db.categorias)
          ..orderBy([(c) => drift.OrderingTerm(expression: c.orden)]))
        .get();

    final etiquetasRows = await _db.customSelect(
      '''
      SELECT categoria_id, nombre
      FROM categoria_etiquetas
      WHERE activa = 1
      ORDER BY id ASC
      ''',
    ).get();

    final map = <int, List<String>>{};
    for (final row in etiquetasRows) {
      final data = row.data;
      final categoriaId = (data['categoria_id'] as int?) ?? 0;
      final nombre = ((data['nombre'] as String?) ?? '').trim();
      if (categoriaId <= 0 || nombre.isEmpty) continue;
      map.putIfAbsent(categoriaId, () => []).add(nombre);
    }

    if (!mounted) return;
    setState(() {
      _categorias = categorias;
      _etiquetas = map;
      _loading = false;
    });
  }

  Future<void> _guardarEtiquetas({
    required int categoriaId,
    required String csvEtiquetas,
  }) async {
    final etiquetas = csvEtiquetas
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    await _db.customStatement(
      'DELETE FROM categoria_etiquetas WHERE categoria_id = ?',
      [categoriaId],
    );

    for (final etiqueta in etiquetas) {
      await _db.customStatement(
        'INSERT INTO categoria_etiquetas (categoria_id, nombre, activa) VALUES (?, ?, 1)',
        [categoriaId, etiqueta],
      );
    }
  }

  Future<void> _crearCategoria() async {
    final nombreCtrl = TextEditingController();
    final etiquetasCtrl = TextEditingController();
    bool habilitarEtiquetas = false;

    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocalState) => AlertDialog(
          title: const Text('Nueva categoria'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: 10),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Etiquetas personalizadas'),
                  value: habilitarEtiquetas,
                  onChanged: (value) {
                    setLocalState(() => habilitarEtiquetas = value);
                  },
                ),
                TextField(
                  controller: etiquetasCtrl,
                  enabled: habilitarEtiquetas,
                  decoration: const InputDecoration(
                    labelText: 'Etiquetas por coma',
                    hintText: 'Jugosa, Carne seca, Bebida fria',
                  ),
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
    if (nombre.isEmpty) return;

    final orden = _categorias.isEmpty ? 1 : _categorias.last.orden + 1;
    final categoriaId = await _db.into(_db.categorias).insert(
          CategoriasCompanion.insert(
            nombre: nombre,
            orden: drift.Value(orden),
          ),
        );

    await _guardarEtiquetas(
      categoriaId: categoriaId,
      csvEtiquetas: habilitarEtiquetas ? etiquetasCtrl.text : '',
    );

    await _cargar();
  }

  Future<void> _editarCategoria(Categoria categoria) async {
    final nombreCtrl = TextEditingController(text: categoria.nombre);
    final etiquetasIniciales = _etiquetas[categoria.id] ?? const [];
    final etiquetasCtrl =
        TextEditingController(text: etiquetasIniciales.join(', '));
    bool habilitarEtiquetas = etiquetasIniciales.isNotEmpty;

    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocalState) => AlertDialog(
          title: const Text('Editar categoria'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: 10),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Etiquetas personalizadas'),
                  value: habilitarEtiquetas,
                  onChanged: (value) {
                    setLocalState(() => habilitarEtiquetas = value);
                  },
                ),
                TextField(
                  controller: etiquetasCtrl,
                  enabled: habilitarEtiquetas,
                  decoration: const InputDecoration(
                    labelText: 'Etiquetas por coma',
                    hintText: 'Jugosa, Carne seca, Bebida fria',
                  ),
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
    if (nombre.isEmpty) return;

    await (_db.update(_db.categorias)..where((c) => c.id.equals(categoria.id)))
        .write(
      CategoriasCompanion(nombre: drift.Value(nombre)),
    );

    await _guardarEtiquetas(
      categoriaId: categoria.id,
      csvEtiquetas: habilitarEtiquetas ? etiquetasCtrl.text : '',
    );

    await _cargar();
  }

  Future<void> _eliminarCategoria(Categoria categoria) async {
    final count = await _db.customSelect(
      'SELECT COUNT(*) AS total FROM productos WHERE categoria_id = ?',
      variables: [drift.Variable<int>(categoria.id)],
    ).getSingle();

    final total = (count.data['total'] as int?) ?? 0;
    if (total > 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se puede eliminar, tiene productos asociados.'),
        ),
      );
      return;
    }

    if (!mounted) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar categoria'),
        content: Text('Deseas eliminar ${categoria.nombre}?'),
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

    await _db.customStatement(
      'DELETE FROM categoria_etiquetas WHERE categoria_id = ?',
      [categoria.id],
    );
    await (_db.delete(_db.categorias)..where((c) => c.id.equals(categoria.id)))
        .go();

    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Categorias',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _crearCategoria,
        icon: const Icon(Icons.add),
        label: const Text('Nueva categoria'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent))
          : _categorias.isEmpty
              ? const Center(child: Text('No hay categorias.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _categorias.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final c = _categorias[i];
                    final tags = (_etiquetas[c.id] ?? const []).join(', ');
                    return Card(
                      child: ListTile(
                        title: Text(c.nombre),
                        subtitle: Text(
                          tags.isEmpty
                              ? 'Sin etiquetas personalizadas (por defecto)'
                              : 'Etiquetas: $tags',
                        ),
                        trailing: Wrap(
                          spacing: 4,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _editarCategoria(c),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: AppColors.error),
                              onPressed: () => _eliminarCategoria(c),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
