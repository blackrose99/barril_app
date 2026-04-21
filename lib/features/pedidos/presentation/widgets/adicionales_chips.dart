import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AdicionalesChips extends StatelessWidget {
  final List<String> adicionales;
  final List<String> seleccionados;
  final void Function(String) onToggle;

  const AdicionalesChips({
    super.key,
    required this.adicionales,
    required this.seleccionados,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: adicionales.map((nombre) {
        final activo = seleccionados.contains(nombre);
        return GestureDetector(
          onTap: () => onToggle(nombre),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: activo ? AppColors.accent : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: activo
                    ? AppColors.accent
                    : AppColors.textMuted.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              nombre,
              style: TextStyle(
                fontSize: 14,
                fontWeight: activo ? FontWeight.w600 : FontWeight.w400,
                color: activo ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
