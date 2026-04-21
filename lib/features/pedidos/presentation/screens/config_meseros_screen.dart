import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../database/app_database.dart';
import '../../../../injection_container.dart';

class ConfigMeserosScreen extends StatefulWidget {
  const ConfigMeserosScreen({super.key});

  @override
  State<ConfigMeserosScreen> createState() => _ConfigMeserosScreenState();
}

class _ConfigMeserosScreenState extends State<ConfigMeserosScreen> {
  final AppDatabase _db = sl<AppDatabase>();

  bool _loading = true;
  List<Mesero> _meseros = const [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _loading = true);

    final meseros = await (_db.select(_db.meseros)
          ..orderBy([(m) => drift.OrderingTerm(expression: m.id)]))
        .get();

    if (!mounted) return;
    setState(() {
      _meseros = meseros;
      _loading = false;
    });
  }

  Future<void> _guardarMesero({Mesero? mesero}) async {
    final ctrl = TextEditingController(text: mesero?.nombre ?? '');

    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(mesero == null ? 'Nuevo mesero' : 'Editar mesero'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nombre del mesero',
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
    );

    if (ok != true) return;

    final nombre = ctrl.text.trim();
    if (nombre.isEmpty) return;

    final duplicado = _meseros.any(
      (item) =>
          item.id != (mesero?.id ?? 0) &&
          item.nombre.trim().toLowerCase() == nombre.toLowerCase(),
    );
    if (duplicado) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ya existe un mesero con ese nombre.')),
      );
      return;
    }

    if (mesero == null) {
      await _db.into(_db.meseros).insert(
            MeserosCompanion.insert(nombre: nombre),
          );
    } else {
      await (_db.update(_db.meseros)..where((m) => m.id.equals(mesero.id)))
          .write(MeserosCompanion(nombre: drift.Value(nombre)));
    }

    await _cargar();
  }

  Future<void> _eliminarMesero(Mesero mesero) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar mesero'),
        content: Text('Deseas eliminar ${mesero.nombre}?'),
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

    await (_db.delete(_db.meseros)..where((m) => m.id.equals(mesero.id))).go();
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
          'Meseros',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _guardarMesero(),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo mesero'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : _meseros.isEmpty
              ? const Center(child: Text('No hay meseros configurados.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _meseros.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final mesero = _meseros[i];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: Text(mesero.nombre),
                        trailing: Wrap(
                          spacing: 4,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _guardarMesero(mesero: mesero),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: AppColors.error),
                              onPressed: () => _eliminarMesero(mesero),
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
