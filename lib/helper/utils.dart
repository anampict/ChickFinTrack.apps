import 'package:intl/intl.dart';

// bikin helper (bisa taruh di utils)
String formatRupiah(num value) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(value);
}
