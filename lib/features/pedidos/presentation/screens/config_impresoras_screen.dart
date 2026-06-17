import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../database/app_database.dart';
import '../../../../injection_container.dart';
import '../../../impresion/bluetooth_printer_service.dart';
import '../../../impresion/ticket_builder.dart';
import '../../../impresion/ticket_data.dart';

class ConfigImpresorasScreen extends StatefulWidget {
  const ConfigImpresorasScreen({super.key});

  @override
  State<ConfigImpresorasScreen> createState() => _ConfigImpresorasScreenState();
}

class _ConfigImpresorasScreenState extends State<ConfigImpresorasScreen> {
  final AppDatabase _db = sl<AppDatabase>();
  final BluetoothPrinterService _printerService = const BluetoothPrinterService();

  bool _loading = true;
  bool _escaneando = false;
  bool _imprimiendoPrueba = false;
  String _printerDeviceId = '';
  String _printerDeviceName = '';
  AnchoPapel _anchoPapel = AnchoPapel.mm58;
  List<ScanResult> _encontrados = const [];

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

  Future<String> _leerConfig(String clave, {String fallback = ''}) async {
    final row = await (_db.select(_db.configuracion)
          ..where((c) => c.clave.equals(clave)))
        .getSingleOrNull();
    return row?.valor ?? fallback;
  }

  Future<void> _cargar() async {
    setState(() => _loading = true);

    final deviceId = await _leerConfig('printer_device_id');
    final deviceName = await _leerConfig('printer_device_name');
    final anchoRaw = await _leerConfig('printer_paper_width', fallback: '32');
    final ancho = AnchoPapelX.desdeCaracteres(int.tryParse(anchoRaw) ?? 32);

    if (!mounted) return;
    setState(() {
      _printerDeviceId = deviceId;
      _printerDeviceName = deviceName;
      _anchoPapel = ancho;
      _loading = false;
    });
  }

  Future<void> _buscarImpresoras() async {
    setState(() {
      _escaneando = true;
      _encontrados = const [];
    });

    try {
      final resultados = await _printerService.scanPrinters();
      if (!mounted) return;
      setState(() => _encontrados = resultados
          .where((r) => r.device.platformName.isNotEmpty || r.advertisementData.advName.isNotEmpty)
          .toList());

      if (_encontrados.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se encontraron dispositivos Bluetooth cercanos. Asegúrate de que la impresora esté encendida y en modo visible.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _escaneando = false);
    }
  }

  Future<void> _seleccionarImpresora(ScanResult resultado) async {
    final id = resultado.device.remoteId.str;
    final nombre = resultado.device.platformName.isNotEmpty
        ? resultado.device.platformName
        : resultado.advertisementData.advName;

    await _upsertConfig('printer_device_id', id);
    await _upsertConfig('printer_device_name', nombre.isEmpty ? id : nombre);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Impresora "$nombre" guardada como predeterminada.')),
    );
    await _cargar();
  }

  Future<void> _olvidarImpresora() async {
    await _upsertConfig('printer_device_id', '');
    await _upsertConfig('printer_device_name', '');
    await _cargar();
  }

  Future<void> _cambiarAnchoPapel(AnchoPapel ancho) async {
    await _upsertConfig('printer_paper_width', ancho.caracteresPorLinea.toString());
    setState(() => _anchoPapel = ancho);
  }

  Future<void> _imprimirTicketPrueba() async {
    if (_printerDeviceId.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero conecta una impresora.')),
      );
      return;
    }

    setState(() => _imprimiendoPrueba = true);
    try {
      final nombreNegocio = await _leerConfig('nombre_negocio', fallback: 'POSify');
      final ticketPrueba = TicketData(
        nombreNegocio: nombreNegocio,
        pedidoId: 0,
        numeroTurno: 1,
        tipo: 'mesa',
        referencia: 'Mesa de prueba',
        cliente: '',
        mesero: '',
        items: const [],
        valorDomicilio: 0,
        cobrarDomicilio: false,
        estadoPedido: 'cerrado',
        fecha: DateTime.now(),
      );

      final bytes = await buildEscPosBytes(ticketPrueba, ancho: _anchoPapel);
      final device = await _printerService.connect(_printerDeviceId);
      final exito = device != null && await _printerService.printBytes(device, bytes);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            exito
                ? 'Ticket de prueba enviado a $_printerDeviceName.'
                : 'No se pudo conectar a la impresora. Verifica que esté encendida y vinculada.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _imprimiendoPrueba = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Impresoras POS', style: TextStyle(color: Colors.white)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Impresora térmica predeterminada',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      if (_printerDeviceId.trim().isEmpty)
                        const Text(
                          'No hay ninguna impresora conectada todavía.',
                          style: TextStyle(color: AppColors.textMuted),
                        )
                      else
                        Row(
                          children: [
                            const Icon(Icons.print, color: AppColors.accent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _printerDeviceName.isEmpty ? _printerDeviceId : _printerDeviceName,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            TextButton(
                              onPressed: _olvidarImpresora,
                              child: const Text('Olvidar'),
                            ),
                          ],
                        ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _imprimiendoPrueba ? null : _imprimirTicketPrueba,
                        icon: _imprimiendoPrueba
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.receipt_long),
                        label: const Text('Imprimir ticket de prueba'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ancho de papel', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      SegmentedButton<AnchoPapel>(
                        segments: AnchoPapel.values
                            .map((a) => ButtonSegment(value: a, label: Text(a.etiqueta)))
                            .toList(),
                        selected: {_anchoPapel},
                        onSelectionChanged: (s) => _cambiarAnchoPapel(s.first),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Dispositivos Bluetooth cercanos',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: _escaneando ? null : _buscarImpresoras,
                      icon: _escaneando
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.bluetooth_searching),
                      label: Text(_escaneando ? 'Buscando...' : 'Buscar'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_encontrados.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Toca "Buscar" para detectar impresoras Bluetooth disponibles.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  )
                else
                  ..._encontrados.map((r) {
                    final nombre = r.device.platformName.isNotEmpty
                        ? r.device.platformName
                        : (r.advertisementData.advName.isEmpty
                            ? r.device.remoteId.str
                            : r.advertisementData.advName);
                    final esActual = r.device.remoteId.str == _printerDeviceId;
                    return Card(
                      color: esActual ? AppColors.accent.withValues(alpha: 0.12) : Colors.white,
                      child: ListTile(
                        leading: const Icon(Icons.print_outlined),
                        title: Text(nombre),
                        subtitle: Text('Señal: ${r.rssi} dBm'),
                        trailing: esActual
                            ? const Icon(Icons.check_circle, color: AppColors.accent)
                            : const Icon(Icons.chevron_right),
                        onTap: () => _seleccionarImpresora(r),
                      ),
                    );
                  }),
              ],
            ),
    );
  }
}
