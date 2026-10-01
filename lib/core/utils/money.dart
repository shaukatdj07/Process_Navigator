import 'package:intl/intl.dart';

class Money {
  const Money._();

  static final NumberFormat _plain = NumberFormat('#,##0');

  static String rs(num amount) => 'Rs. ${_plain.format(amount.round())}';

  static String km(double value) => '${value.toStringAsFixed(1)} km';
}
