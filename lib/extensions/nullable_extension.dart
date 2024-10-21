import 'dart:ui';

extension DoubleIsNull on double? {
  bool get isNull => this == null;
  bool get exists => this != null;
  bool get isZero => this == 0;
}

extension IntIsNull on int? {
  bool get isNull => this == null;
  bool get exists => this != null;
  bool get isZero => this == 0;
  bool get isNegative => exists && this! < 0;
  bool get isPositive => exists && this! > 0;
}

extension StringIsNull on String? {
  bool get isNull => this == null;
  bool get exists => this != null;
  bool get isEmpty => !isNull && this! == '';
  bool get isNotEmpty => !isNull && this! != '';
  ///forces return of a string when the value is null, else returns the value as non-optional string
  String get orEmpty => this ?? '';
}

extension BoolIsNull on bool? {
  bool get isNull => this == null;
  bool get exists => this != null;
}

extension ObjectIsNull on Object? {
  bool get isNull => this == null;
  bool get exists => this != null;
}

extension ColorIsNull on Color? {
  bool get isNull => this == null;
  bool get exists => this != null;
  //return a non-null color. The color turns transparent if null.
  Color get force => isNull ? const Color(0x00000000) : this!; 
}