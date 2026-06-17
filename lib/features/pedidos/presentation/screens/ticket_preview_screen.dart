import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../database/app_database.dart';
import '../../../../injection_container.dart';
import '../../../impresion/bluetooth_printer_service.dart';
import '../../../impresion/ticket_builder.dart';
import '../../../impresion/ticket_data.dart';
import '../../../impresion/ticket_pdf.dart';
import 'config_impresoras_screen.dart';

/// Previsualiza un pedido como ticket y permite imprimirlo en una POS
/// térmica, exportarlo/imprimirlo como PDF o compartirlo por WhatsApp.
class TicketPreviewScreen extends StatefulWidget {
  final TicketData data;

  const TicketPreviewScreen({super.key, required this.data});

  @override
  State<TicketPreviewScreen> createState() => _TicketPreviewScreenState();
}

class _TicketPreviewScreenState extends State<TicketPreviewScreen> {
  final AppDatabase _db = sl<AppDatabase>();
  final BluetoothPrinterService _printerService = const BluetoothPrinterService();

  bool _cargandoConfig = true;
  bool _accionEnCurso = false;
  String _printerDeviceId = '';
  String _printerDeviceName = '';
  AnchoPapel _anchoPapel = AnchoPapel.mm58;

  @override
  void initState() {
    super.initState();
    _cargarConfigImpresora();
  }

  Future<String> _leerConfig(String clave, {String fallback = ''}) async {
    final row = await (_db.select(_db.configuracion)
          ..where((c) => c.clave.equals(clave)))
        .getSingleOrNull();
    return row?.valor ?? fallback;
  }

  Future<void> _cargarConfigImpresora() async {
    final deviceId = await _leerConfig('printer_device_id');
    final deviceName = await _leerConfig('printer_device_name');
    final anchoRaw = await _leerConfig('printer_paper_width', fallback: '32');

    if (!mounted) return;
    setState(() {
      _printerDeviceId = deviceId;
      _printerDeviceName = deviceName;
      _anchoPapel = AnchoPapelX.desdeCaracteres(int.tryParse(anchoRaw) ?? 32);
      _cargandoConfig = false;
    });
  }

  Future<void> _imprimirEnTermica() async {
    if (_printerDeviceId.trim().isEmpty) {
      final irAConfigurar = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Sin impresora configurada'),
          content: const Text(
            'Aún no has conectado una impresora térmica. Puedes configurarla ahora o imprimir usando el diálogo del sistema.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Imprimir con el sistema'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Configurar impresora'),
            ),
          ],
        ),
      );

      if (irAConfigurar == true) {
        if (!mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ConfigImpresorasScreen()),
        );
        await _cargarConfigImpresora();
        return;
      }

      await _imprimirConSistema();
      return;
    }

    setState(() => _accionEnCurso = true);
    try {
      final bytes = await buildEscPosBytes(widget.data, ancho: _anchoPapel);
      final device = await _printerService.connect(_printerDeviceId);
      final exito = device != null && await _printerService.printBytes(device, bytes);

      if (!mounted) return;
      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ticket enviado a $_printerDeviceName.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo conectar a la impresora térmica. Se abrirá la impresión del sistema.',
            ),
          ),
        );
        await _imprimirConSistema();
      }
    } finally {
      if (mounted) setState(() => _accionEnCurso = false);
    }
  }

  Future<void> _imprimirConSistema() async {
    await Printing.layoutPdf(onLayout: (format) async => buildTicketPdf(widget.data));
  }

  Future<File> _generarArchivoPdf() async {
    final bytes = await buildTicketPdf(widget.data);
    final dir = await getTemporaryDirectory();
    final nombre = 'ticket_${widget.data.codigoTurno}_${widget.data.pedidoId}.pdf';
    final file = File('${dir.path}/$nombre');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> _compartirWhatsapp() async {
    setState(() => _accionEnCurso = true);
    try {
      final file = await _generarArchivoPdf();
      if (!mounted) return;
      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'Pedido ${widget.data.codigoTurno} - Total: ${formatMoney(widget.data.total)}',
      );
    } finally {
      if (mounted) setState(() => _accionEnCurso = false);
    }
  }

  Future<void> _exportarPdf() async {
    setState(() => _accionEnCurso = true);
    try {
      await _imprimirConSistema();
    } finally {
      if (mounted) setState(() => _accionEnCurso = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final textoTicket = buildPlainTicket(data, ancho: _anchoPapel);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Vista previa del ticket', style: TextStyle(color: Colors.white)),
      ),
      body: _cargandoConfig
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Container(
                          width: 360,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                data.nombreNegocio.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                data.tituloEstado,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    data.codigoTurno,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              Text(
                                textoTicket,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12.5,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: _accionEnCurso ? null : _imprimirEnTermica,
                                icon: const Icon(Icons.print),
                                label: const Text('Imprimir en POS'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _accionEnCurso ? null : _exportarPdf,
                                icon: const Icon(Icons.picture_as_pdf_outlined),
                                label: const Text('PDF'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _accionEnCurso ? null : _compartirWhatsapp,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF25D366),
                              side: const BorderSide(color: Color(0xFF25D366)),
                            ),
                            icon: const Icon(Icons.share_outlined),
                            label: const Text('Compartir por WhatsApp'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
