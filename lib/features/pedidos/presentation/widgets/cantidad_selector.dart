import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CantidadSelector extends StatelessWidget {
  final int cantidad;
  final VoidCallback onIncrementar;
  final VoidCallback onDecrementar;

  const CantidadSelector({
    super.key,
    required this.cantidad,
    required this.onIncrementar,
    required this.onDecrementar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Btn(
          icon: Icons.remove,
          onTap: cantidad > 1 ? onDecrementar : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$cantidad',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
        _Btn(icon: Icons.add, onTap: onIncrementar),
      ],
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _Btn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.accent
              : AppColors.textMuted.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
