import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

mixin ValidateMixin {
  //iphone 15 default resolution
  ///Width used for devices that are not mobile
  final defaultWidth = 1080.0;
  ///height used for devices that are not mobile
  final defaultHeight = 1920.0;
  
  bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  ///calculates the width of the screen based on whether the device is mobile or not
  double calculatedWidth(context) => isMobile ? MediaQuery.of(context).size.width : defaultWidth;
  ///calculates the height of the screen based on whether the device is mobile or not
  double calculatedHeight(context) => isMobile ? MediaQuery.of(context).size.height : defaultHeight;
}