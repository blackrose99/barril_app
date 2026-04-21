import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../database/app_database.dart';
import '../../../../injection_container.dart';

class ConfigImpresorasScreen extends StatefulWidget {
  const ConfigImpresorasScreen({super.key});

  @override
  State<ConfigImpresorasScreen> createState() => _ConfigImpresorasScreenState();
}

class _ConfigImpresorasScreenState extends State<ConfigImpresorasScreen> {
  final AppDatabase _db = sl<AppDatabase>();

  bool _loading = true;
  List<String> _impresoras = const [];
  String _predeterminada = '';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _upsertConfig(String clave, String valor) async {
    final actual = await (_db.select(_db.configuracion)
          ..where((c) => c.clave.equals(clave)))
        .getSingleOrNull();
    if (actual == null) {
      await _db
          .into(_db.configuracion)
          .insert(ConfiguracionCompanion.insert(clave: clave, valor: valor));
      return;
    }

    await (_db.update(_db.configuracion)..where((c) => c.clave.equals(clave)))
        .write(ConfiguracionCompanion(valor: drift.Value(valor)));
  }

  Future<void> _cargar() async {
    setState(() => _loading = true);

    await _upsertConfig('printer_devices', 'POS principal');
    await _upsertConfig('printer_default', 'POS principal');

    final devices = await (_db.select(_db.configuracion)
          ..where((c) => c.clave.equals('printer_devices')))
        .getSingle();
    final printerDefault = await (_db.select(_db.configuracion)
          ..where((c) => c.clave.equals('printer_default')))
        .getSingle();

    if (!mounted) return;
    setState(() {
      _impresoras = devices.valor
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      _predeterminada = printerDefault.valor;
      _loading = false;
    });
  }

  Future<void> _agregar() async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva impresora POS'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Nombre de impresora'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );

    if (ok != true) return;
    final nombre = ctrl.text.trim();
    if (nombre.isEmpty) return;

    final lista = [..._impresoras];
    if (!lista.contains(nombre)) lista.add(nombre);

    await _upsertConfig('printer_devices', lista.join(','));
    if (_predeterminada.isEmpty) {
      await _upsertConfig('printer_default', nombre);
    }

    await _cargar();
  }

  Future<void> _eliminar(String impresora) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar impresora'),
        content: Text('Deseas eliminar $impresora?'),
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

    final lista = [..._impresoras]..remove(impresora);
    final nuevoDefault = lista.isNotEmpty ? lista.first : 'POS principal';

    await _upsertConfig('printer_devices', lista.join(','));
    await _upsertConfig('printer_default',
        _predeterminada == impresora ? nuevoDefault : _predeterminada);

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
          'Impresoras POS',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregar,
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent))
          : _impresoras.isEmpty
              ? const Center(child: Text('No hay impresoras configuradas.'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _impresoras.contains(_predeterminada)
                          ? _predeterminada
                          : _impresoras.first,
                      decoration: const InputDecoration(
                        labelText: 'Impresora predeterminada',
                      ),
                      items: _impresoras
                          .map(
                              (p) => DropdownMenuItem(value: p, child: Text(p)))
                          .toList(),
                      onChanged: (value) async {
                        if (value == null) return;
                        await _upsertConfig('printer_default', value);
                        await _cargar();
                      },
                    ),
                    const SizedBox(height: 12),
                    ..._impresoras.map(
                      (p) => ListTile(
                        title: Text(p),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.error),
                          onPressed: () => _eliminar(p),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
