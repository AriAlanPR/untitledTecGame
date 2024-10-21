
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';

extension StringExtension on String {
  
  ///capitalizes the first letter of the string
  String capitalize() {
    if(isEmpty) {
      return this;
    }

    return "${this[0].toUpperCase()}${substring(1)}";
  }

  /// try to get color from a hex string, if it fails it returns null
  Color? fromHex() {
    if(isEmpty || length != 7 || substring(0, 1) != '#') {
      return null;
    }

    //NOTE - "ff" appended to the hex string means the alpha channel will be 100%
    return Color(int.parse("ff${(this).replaceAll('#', '')}", radix: 16)); 
  }

  ///validates if the string is a valid number
  bool isNumeric() {
    if (isEmpty) {
      return false;
    }
    return double.tryParse(this) != null;
  }

  ///Tries to parse the string as an integer and returns it if successful.
  ///
  ///If the string is not a valid number, it returns null.
  int? asInt() {
    if (isNumeric()) {
      return int.parse(this);
    }
    return null;
  }
  
  ///Tries to parse the string as a double and returns it if successful.
  ///
  ///If the string is not a valid number, it returns null.
  double? asDouble() {
    if (isNumeric()) {
      return double.parse(this);
    }
    return null;
  }

  //formatDate
  ///Converts a string in miliseconds format to a string in the specified format.
  ///
  ///The [format] parameter is a string that follows the [DateFormat] rules.
  ///
  ///If the string is empty or not in miliseconds format, it returns the string "date_missing" localized.
  ///
  ///If it fails to parse the string, it also returns the string "date_missing" localized.
  String timestampDateFormat({String format = "dd MMMM, yyyy HH:mm"}) {
    final dateMissing = "date_missing".i18n();
    try {
      if(isEmpty || !isNumeric()) {
        return dateMissing;
      }
      
      final date = DateTime.fromMillisecondsSinceEpoch(int.parse(this) * 1000);
      final formatter = DateFormat(format);

      return formatter.format(date);
    } catch (e) {
      return dateMissing;
    }
  }
  
  //fromStringToDate
  ///converts a string in miliseconds format to DateTime, returns null if it fails
  DateTime? timestampDate() {
    try {
      if (isEmpty || !isNumeric()) {
        return null;
      }
      final ms = int.parse(this);
      return DateTime.fromMillisecondsSinceEpoch(ms);
    } catch (e) {
      return null;
    }
  }

  ///converts a string from the specified format to DateTime, returns null if it fails
  DateTime? toDateTime({required String dateTimeFormat}) {
    try {
      return DateFormat('yyyy-MM-dd').parse(this);
    } catch (e) {
      return null;
    }
  }
}