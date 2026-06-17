import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Servicio reutilizable para descubrir, conectar e imprimir en impresoras
/// térmicas Bluetooth (perfil BLE genérico de escritura). Centraliza la
/// lógica que antes vivía duplicada y ad-hoc dentro de las pantallas.
class BluetoothPrinterService {
  const BluetoothPrinterService();

  /// Escanea dispositivos BLE cercanos durante [timeout] y retorna los
  /// resultados encontrados (deduplicados por dispositivo).
  Future<List<ScanResult>> scanPrinters({
    Duration timeout = const Duration(seconds: 6),
  }) async {
    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }

    final encontrados = <String, ScanResult>{};
    final sub = FlutterBluePlus.scanResults.listen((resultados) {
      for (final r in resultados) {
        encontrados[r.device.remoteId.str] = r;
      }
    });

    try {
      await FlutterBluePlus.startScan(timeout: timeout);
      await FlutterBluePlus.isScanning.where((scanning) => !scanning).first;
    } finally {
      await sub.cancel();
    }

    return encontrados.values.toList();
  }

  /// Reconstruye un [BluetoothDevice] a partir de un remoteId guardado
  /// previamente y se conecta a él (si no estaba ya conectado).
  Future<BluetoothDevice?> connect(String remoteId) async {
    if (remoteId.trim().isEmpty) return null;
    try {
      final device = BluetoothDevice.fromId(remoteId);
      if (!device.isConnected) {
        await device.connect(timeout: const Duration(seconds: 10));
      }
      return device;
    } catch (_) {
      return null;
    }
  }

  /// Busca la primera característica con permiso de escritura y envía los
  /// [bytes] en bloques (las impresoras BLE suelen tener un MTU pequeño).
  Future<bool> printBytes(BluetoothDevice device, List<int> bytes) async {
    try {
      if (!device.isConnected) {
        await device.connect(timeout: const Duration(seconds: 10));
      }

      final servicios = await device.discoverServices();

      BluetoothCharacteristic? writable;
      for (final s in servicios) {
        for (final c in s.characteristics) {
          if (c.properties.write || c.properties.writeWithoutResponse) {
            writable = c;
            break;
          }
        }
        if (writable != null) break;
      }

      if (writable == null) return false;

      const int maxChunk = 180;
      for (int i = 0; i < bytes.length; i += maxChunk) {
        final fin = (i + maxChunk < bytes.length) ? i + maxChunk : bytes.length;
        final chunk = bytes.sublist(i, fin);
        await writable.write(
          chunk,
          withoutResponse: writable.properties.writeWithoutResponse,
        );
      }

      return true;
    } catch (_) {
      return false;
    }
  }
}
