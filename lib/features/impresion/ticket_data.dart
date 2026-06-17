import '../pedidos/domain/entities/item_pedido.dart';

/// Ancho de papel de la impresora térmica configurada por el negocio.
enum AnchoPapel { mm58, mm80 }

extension AnchoPapelX on AnchoPapel {
  int get caracteresPorLinea => this == AnchoPapel.mm58 ? 32 : 48;

  String get etiqueta => this == AnchoPapel.mm58 ? '58mm (32 col)' : '80mm (48 col)';

  static AnchoPapel desdeCaracteres(int caracteres) {
    return caracteres >= 48 ? AnchoPapel.mm80 : AnchoPapel.mm58;
  }
}

/// Datos consolidados de un pedido listos para renderizarse como ticket
/// térmico, texto plano o factura PDF. Un único modelo evita duplicar el
/// formateo entre los distintos canales de salida.
class TicketData {
  final String nombreNegocio;
  final int pedidoId;
  final int numeroTurno;
  final String tipo; // mesa | domicilio
  final String referencia;
  final String cliente;
  final String mesero;
  final List<ItemPedido> items;
  final double valorDomicilio;
  final bool cobrarDomicilio;
  final String estadoPedido; // abierto | cerrado | cancelado
  final DateTime fecha;

  const TicketData({
    required this.nombreNegocio,
    required this.pedidoId,
    required this.numeroTurno,
    required this.tipo,
    required this.referencia,
    required this.cliente,
    required this.mesero,
    required this.items,
    required this.valorDomicilio,
    required this.cobrarDomicilio,
    required this.estadoPedido,
    required this.fecha,
  });

  bool get esDomicilio => tipo == 'domicilio';

  double get subtotal => items.fold(0, (s, i) => s + i.subtotal);

  double get domicilioCobrado => (esDomicilio && cobrarDomicilio) ? valorDomicilio : 0;

  double get total => subtotal + domicilioCobrado;

  String get codigoTurno => codigoTurnoDesde(numeroTurno);

  String get tituloEstado {
    switch (estadoPedido) {
      case 'cancelado':
        return 'PEDIDO CANCELADO';
      case 'cerrado':
      case 'pagado':
        return 'FACTURA';
      default:
        return 'PEDIDO EN PREPARACIÓN';
    }
  }

  String get referenciaONombreTipo =>
      referencia.trim().isNotEmpty ? referencia.trim() : (esDomicilio ? 'Domicilio' : 'Mesa');
}

String codigoTurnoDesde(int numero) => 'T-${numero.toString().padLeft(3, '0')}';

String formatFechaTicket(DateTime fecha) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(fecha.day)}/${two(fecha.month)}/${fecha.year} ${two(fecha.hour)}:${two(fecha.minute)}';
}
