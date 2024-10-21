// import 'dart:io';
// import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

//NOTE - verify code is not outside an if with kdebugmode validated before making release build
//error handler
void printerr(Object e, StackTrace? stackTrace) {
  if (kDebugMode) {
    //debug foundation output
    debugPrint("Error: $e");
    debugPrint("Stack: $stackTrace");
    //io output
    // stderr.writeln("Error: $e");
    // stderr.writeln("Stack: $stackTrace");
  }
  
  // developer.log("Error: $e", stackTrace: stackTrace);
}

void println(Object? message) {
  if (kDebugMode) {
    //debug foundation output
    if(message is String) {
      debugPrint(message);
      return;
    }
    
    debugPrint(message.toString());    
    //io output
    // stdout.writeln(message);
  }

  // developer.log(message);
}