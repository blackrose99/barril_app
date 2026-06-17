import 'dart:convert';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

import '../../core/utils/money_formatter.dart';
import 'ticket_data.dart';

PaperSize _paperSizeDe(AnchoPapel ancho) =>
    ancho == AnchoPapel.mm58 ? PaperSize.mm58 : PaperSize.mm80;

String _centrar(String texto, int ancho) {
  final t = texto.length > ancho ? texto.substring(0, ancho) : texto;
  final espacios = ancho - t.length;
  final izq = espacios ~/ 2;
  final der = espacios - izq;
  return '${' ' * izq}$t${' ' * der}';
}

String _linea(int ancho, [String ch = '-']) => ch * ancho;

String _dosColumnas(String izquierda, String derecha, int ancho) {
  final espacio = ancho - izquierda.length - derecha.length;
  if (espacio < 1) {
    final maxIzq = ancho - derecha.length - 1;
    final recortada = maxIzq > 0 && izquierda.length > maxIzq
        ? izquierda.substring(0, maxIzq)
        : izquierda;
    final relleno = ancho - recortada.length - derecha.length;
    return '$recortada${' ' * (relleno > 0 ? relleno : 1)}$derecha';
  }
  return '$izquierda${' ' * espacio}$derecha';
}

/// Texto plano del ticket, usado tanto para la vista previa en pantalla como
/// de respaldo si no hay impresora térmica conectada.
String buildPlainTicket(TicketData data, {AnchoPapel ancho = AnchoPapel.mm58}) {
  final w = ancho.caracteresPorLinea;
  final buffer = StringBuffer();

  buffer.writeln(_centrar(data.nombreNegocio.toUpperCase(), w));
  buffer.writeln(_centrar(data.tituloEstado, w));
  buffer.writeln(_linea(w, '='));
  buffer.writeln(_centrar(data.codigoTurno, w));
  buffer.writeln(_linea(w, '='));
  buffer.writeln('${data.esDomicilio ? 'Domicilio' : 'Mesa'}: ${data.referenciaONombreTipo}');
  if (data.cliente.trim().isNotEmpty) buffer.writeln('Cliente: ${data.cliente.trim()}');
  if (data.mesero.trim().isNotEmpty) buffer.writeln('Mesero: ${data.mesero.trim()}');
  buffer.writeln('Fecha: ${formatFechaTicket(data.fecha)}');
  buffer.writeln('Pedido #${data.pedidoId}');
  buffer.writeln(_linea(w));

  if (data.items.isEmpty) {
    buffer.writeln(_centrar('Sin productos agregados', w));
  } else {
    for (final item in data.items) {
      buffer.writeln('${item.cantidad}x ${item.nombreProducto}');
      if (item.adicionales.isNotEmpty) {
        buffer.writeln('  + ${item.adicionales.join(', ')}');
      }
      if (item.nota.trim().isNotEmpty) {
        buffer.writeln('  Nota: ${item.nota.trim()}');
      }
      buffer.writeln(
        _dosColumnas('  ${formatMoney(item.precio)} c/u', formatMoney(item.subtotal), w),
      );
    }
  }

  buffer.writeln(_linea(w));
  buffer.writeln(_dosColumnas('Subtotal', formatMoney(data.subtotal), w));
  if (data.domicilioCobrado > 0) {
    buffer.writeln(_dosColumnas('Domicilio', formatMoney(data.domicilioCobrado), w));
  }
  buffer.writeln(_linea(w, '='));
  buffer.writeln(_dosColumnas('TOTAL', formatMoney(data.total), w));
  buffer.writeln(_linea(w, '='));
  buffer.writeln(_centrar('Gracias por tu compra', w));

  return buffer.toString();
}

/// Bytes ESC/POS listos para enviar a una impresora térmica Bluetooth.
Future<List<int>> buildEscPosBytes(
  TicketData data, {
  AnchoPapel ancho = AnchoPapel.mm58,
}) async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(_paperSizeDe(ancho), profile, codec: latin1);
  final bytes = <int>[];

  bytes.addAll(generator.text(
    data.nombreNegocio.toUpperCase(),
    styles: const PosStyles(
      align: PosAlign.center,
      bold: true,
      height: PosTextSize.size2,
      width: PosTextSize.size2,
    ),
  ));
  bytes.addAll(generator.text(data.tituloEstado, styles: const PosStyles(align: PosAlign.center)));
  bytes.addAll(generator.hr(ch: '='));
  bytes.addAll(generator.text(
    data.codigoTurno,
    styles: const PosStyles(
      align: PosAlign.center,
      bold: true,
      height: PosTextSize.size3,
      width: PosTextSize.size3,
    ),
    linesAfter: 1,
  ));
  bytes.addAll(generator.hr(ch: '='));
  bytes.addAll(generator.text(
    '${data.esDomicilio ? 'Domicilio' : 'Mesa'}: ${data.referenciaONombreTipo}',
  ));
  if (data.cliente.trim().isNotEmpty) {
    bytes.addAll(generator.text('Cliente: ${data.cliente.trim()}'));
  }
  if (data.mesero.trim().isNotEmpty) {
    bytes.addAll(generator.text('Mesero: ${data.mesero.trim()}'));
  }
  bytes.addAll(generator.text('Fecha: ${formatFechaTicket(data.fecha)}'));
  bytes.addAll(generator.text('Pedido #${data.pedidoId}'));
  bytes.addAll(generator.hr());

  if (data.items.isEmpty) {
    bytes.addAll(generator.text(
      'Sin productos agregados',
      styles: const PosStyles(align: PosAlign.center),
    ));
  } else {
    for (final item in data.items) {
      bytes.addAll(generator.row([
        PosColumn(text: '${item.cantidad}x ${item.nombreProducto}', width: 8),
        PosColumn(
          text: formatMoney(item.subtotal),
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]));
      if (item.adicionales.isNotEmpty) {
        bytes.addAll(generator.text('  + ${item.adicionales.join(', ')}'));
      }
      if (item.nota.trim().isNotEmpty) {
        bytes.addAll(generator.text('  Nota: ${item.nota.trim()}'));
      }
    }
  }

  bytes.addAll(generator.hr());
  bytes.addAll(generator.row([
    PosColumn(text: 'Subtotal', width: 8),
    PosColumn(
      text: formatMoney(data.subtotal),
      width: 4,
      styles: const PosStyles(align: PosAlign.right),
    ),
  ]));
  if (data.domicilioCobrado > 0) {
    bytes.addAll(generator.row([
      PosColumn(text: 'Domicilio', width: 8),
      PosColumn(
        text: formatMoney(data.domicilioCobrado),
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]));
  }
  bytes.addAll(generator.hr(ch: '='));
  bytes.addAll(generator.text(
    'TOTAL  ${formatMoney(data.total)}',
    styles: const PosStyles(align: PosAlign.right, bold: true, height: PosTextSize.size2),
    linesAfter: 1,
  ));
  bytes.addAll(generator.text(
    'Gracias por tu compra',
    styles: const PosStyles(align: PosAlign.center),
  ));
  bytes.addAll(generator.cut());

  return bytes;
}
