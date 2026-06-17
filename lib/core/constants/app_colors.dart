import 'package:flutter/material.dart';

class AppColors {
  // Paleta verde alineada con el ícono de la app (POSify).
  static const Color primary = Color(0xFF146C2E);
  static const Color primaryDark = Color(0xFF0D5022);
  static const Color accent = Color(0xFF1E9E4A);
  static const Color accentLight = Color(0xFF4CC172);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF1F8F2);
  static const Color textPrimary = Color(0xFF1B1B1B);
  static const Color textMuted = Color(0xFF888780);

  // Estados semánticos: distintos del verde de marca para no confundirse con él.
  static const Color success = Color(0xFF00897B);
  static const Color warning = Color(0xFFBA7517);
  static const Color error = Color(0xFFE24B4A);

  // Verde claro = mesa libre/disponible, ámbar claro = mesa ocupada (antes
  // ambos eran azules casi idénticos y no se distinguían de un vistazo).
  static const Color mesaLibre = Color(0xFFE3F4E8);
  static const Color mesaOcupada = Color(0xFFFCEBD5);
}
