import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  ///returns a string in the format yyyy-MM-dd which is the format required for the Bstock API
  String get bstockDate => DateFormat('yyyy-MM-dd').format(this);
}