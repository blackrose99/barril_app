import 'package:intl/intl.dart';

final NumberFormat _moneyFormatter = NumberFormat.decimalPattern('es_CO');

String formatMoney(num value) {
  return '\$${_moneyFormatter.format(value.round())}';
}
