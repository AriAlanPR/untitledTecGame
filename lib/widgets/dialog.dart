
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:localization/localization.dart';
import 'package:untitled_tec_game/extensions/nullable_extension.dart';
import 'package:untitled_tec_game/utils/coolborders.dart';

class MyDialog {
  MyDialog._();

  static void show(BuildContext context, {
      String title = "",
      String message = "",
      String confirmation = "Ok",
      String cancel = "Cancel",
      required Function() onConfirmation,
      Function()? onCancel,
    }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title.i18n()),
          content: Text(message.i18n()),
          actions: [
            ElevatedButton(
              onPressed: () {
                  Navigator.of(context).pop(); // on confirm dialog
                  onConfirmation();
              },
              child: Text(
                confirmation,
                style: const TextStyle(
                  color: Colors.green
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (onCancel != null) {
                  onCancel();
                }
              },
              child: Text(
                cancel,
                style: const TextStyle(
                  color: Colors.red
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showCustom(BuildContext context,{
      List<Widget> actions = const [],
      String title = "",
      String message = "",
    }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: actions,
        );
      },
    );
  }

  static void info(BuildContext context, {
    String title = "",
    String message = "notice",
    String confirmation = "Ok",
    void Function()? onDismiss,
  }) {
    if(title.isEmpty) {
      title = "${"info".i18n()} :";
    }

    showCustom(
      context,
      title: title,
      message: message,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            onDismiss?.call();
          },
          child: Text(
            confirmation,
            style: const TextStyle(
              color: Colors.blue
            ),
          ),
        ),
      ],
    );
  }

  static void showLoadingDialog(BuildContext context, {String? message, double spinnerSize = 32}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (message.exists) ...[
                Text(message!),
                const SizedBox(width: 10),
              ],
              LoadingAnimationWidget.twoRotatingArc(color: Colors.orange, size: 30),
            ],
          ),
        );
      },
    );
  }

  static void modal(BuildContext context, { 
    String title = "", 
    Widget? content,
    required Widget confirmation,
    required Widget cancel,
    Color? confirmationColor,
    Color? cancelColor,
    required void Function() onConfirmation,
    void Function()? onCancel,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final width = MediaQuery.of(context).size.width * 0.9;
        // final height = MediaQuery.of(context).size.height * 0.9;
        const buttonHeight = 50.0;
        const radius = 16.0;

        return Center(
          child: Container(
            width: width,
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: CoolBorders(
                radius: radius,
                borderDesign: BorderDesign.all,
              ).getRadius,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text( //NOTE - title of modal
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontSize: 30,
                  ),
                ),
                Padding( //NOTE - Content of modal
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 12.0,
                  ),
                  child: content, 
                ),
                SizedBox( //NOTE - footer buttons
                  width: width,
                  height: buttonHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Close the dialog
                            Navigator.of(context).pop();

                            if (onCancel != null) {
                              onCancel();
                            }
                          },
                          child: Container( // Cancel
                            height: buttonHeight,
                            decoration: BoxDecoration(
                              color: cancelColor,
                              borderRadius: CoolBorders(
                                radius: radius,
                                borderDesign: BorderDesign.bottomLeft,
                              ).getRadius,
                            ),
                            child: Center(child: cancel),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                            
                            onConfirmation();
                          },
                          child: Container( // Confirmation
                            height: buttonHeight,
                            decoration: BoxDecoration(
                              color: confirmationColor,
                              borderRadius: CoolBorders(
                                radius: radius,
                                borderDesign: BorderDesign.bottomRight,
                              ).getRadius,
                            ),
                            child: Center(child: confirmation),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void notImplementedNotice(BuildContext context) {
    MyDialog.info(
      context, 
      title: "implementation", 
      message: "Pending. Not implemented yet",
      onDismiss: () {},
    );
  }
}
