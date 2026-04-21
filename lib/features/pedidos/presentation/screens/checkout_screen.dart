import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/item_pedido.dart';

String _formatMoney(num value) {
  final formatter = NumberFormat.decimalPattern('es_CO');
  return '\$${formatter.format(value.round())}';
}

class CheckoutScreen extends StatelessWidget {
  final List<ItemPedido> items;
  final int pedidoId;
  final String titulo;
  final bool esDomicilio;
  final double valorDomicilio;

  const CheckoutScreen({
    super.key,
    required this.items,
    required this.pedidoId,
    required this.titulo,
    required this.esDomicilio,
    required this.valorDomicilio,
  });

  double get _subtotal => items.fold(0, (s, i) => s + i.subtotal);
  double get _domicilio => esDomicilio ? valorDomicilio : 0;
  double get _total => _subtotal + _domicilio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Cuenta — $titulo',
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...items.map((item) => _ItemRow(item: item)),
                const SizedBox(height: 12),
                const Divider(),
                _TotalRow(label: 'Subtotal', valor: _subtotal),
                if (esDomicilio)
                  _TotalRow(label: 'Domicilio', valor: _domicilio),
                _TotalRow(label: 'Total', valor: _total, grande: true),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.check_circle_outline, size: 24),
                label: Text(
                  'Pagar ${_formatMoney(_total)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final ItemPedido item;
  const _ItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text('${item.cantidad}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.accent)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.nombreProducto,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
                if (item.adicionales.isNotEmpty)
                  Text(item.adicionales.join(', '),
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          Text(_formatMoney(item.subtotal),
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final double valor;
  final bool grande;

  const _TotalRow({
    required this.label,
    required this.valor,
    this.grande = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: grande ? 18 : 14,
                  fontWeight: grande ? FontWeight.w700 : FontWeight.w400,
                  color: grande ? AppColors.textPrimary : AppColors.textMuted)),
          const Spacer(),
          Text(_formatMoney(valor),
              style: TextStyle(
                  fontSize: grande ? 20 : 15,
                  fontWeight: FontWeight.w700,
                  color: grande ? AppColors.success : AppColors.textPrimary)),
        ],
      ),
    );
  }
}
