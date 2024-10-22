import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:untitled_tec_game/extensions/nullable_extension.dart';
import 'package:untitled_tec_game/mixins/validate_mixin.dart';

class EmptyPage extends StatelessWidget with ValidateMixin {
  final bool showRetry;
  final String? emptyMessage;
  /// Callback function to execute when clicking the refresh button
  final void Function()? refreshFunction;

  EmptyPage({
    super.key,
    required this.refreshFunction,
    this.emptyMessage,
    this.showRetry = true,
  });

  EmptyPage.nonRefreshable({
    super.key,
    this.emptyMessage,
  }): refreshFunction = null,
    showRetry = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: calculatedWidth(context),
      height: calculatedHeight(context),
      color: Colors.white.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text((emptyMessage ?? "empty_message").i18n()),
          if(showRetry) TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black, // Set the text color here
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
      
              if(refreshFunction.exists) {
                refreshFunction!();
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.refresh), // Add your desired icon here
                const SizedBox(width: 8), // Add some spacing between the icon and text
                Text('reintentar'.i18n()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}