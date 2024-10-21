import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class Toast {
  Toast._();

  /// Displays a toast message with the given [message] with a hide action.
  /// Parameters:
  /// - [scaffold]: The [ScaffoldMessengerState] to show the [SnackBar] on.
  /// - [fast]: Whether the animation should display fast.
  static void show(ScaffoldMessengerState scaffold, String message, {bool fast = false}) {
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: fast ? 1 : 2),
        action: SnackBarAction(
          label: 'hide'.i18n(),
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }
  
  /// Displays a toast message with the given [message].
  /// Parameters:
  /// - [scaffold]: The [ScaffoldMessengerState] to show the [SnackBar] on.
  /// - [message]: The content of the toast message.
  /// - [fast]: Whether the animation should display fast.
  static void simple(ScaffoldMessengerState scaffold, String message, {bool fast = false}) {
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: fast ? 1 : 2),
      ),
    );
  }
}