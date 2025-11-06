import 'package:intl/intl.dart';

// bikin helper (bisa taruh di utils)
String formatRupiah(num value) {
  final intValue = value.toInt();
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(intValue);
}

//for date formatting
String formatTanggal(DateTime? date) {
  if (date == null) return "-";
  return DateFormat('dd/MM/yyyy, HH:mm').format(date);
}
