import 'package:flutter/material.dart';
import '../../domain/entities/mesa.dart';
import '../../../../core/constants/app_colors.dart';

class MesaCard extends StatelessWidget {
  final Mesa mesa;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

  const MesaCard({
    super.key,
    required this.mesa,
    required this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final ocupada = mesa.estaOcupada;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: ocupada ? AppColors.mesaOcupada : AppColors.mesaLibre,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ocupada
                ? AppColors.accent.withValues(alpha: 0.5)
                : AppColors.success.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            if (onEdit != null)
              Positioned(
                top: 6,
                right: 6,
                child: IconButton(
                  tooltip: 'Editar mesa',
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  visualDensity: VisualDensity.compact,
                  color: AppColors.textMuted,
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  ocupada ? Icons.restaurant : Icons.chair_outlined,
                  size: 36,
                  color: ocupada ? AppColors.accent : AppColors.success,
                ),
                const SizedBox(height: 8),
                Text(
                  mesa.nombre,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ocupada ? AppColors.accent : AppColors.success,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: ocupada
                        ? AppColors.accent.withValues(alpha: 0.12)
                        : AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ocupada ? 'Ocupada' : 'Libre',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ocupada ? AppColors.accent : AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
