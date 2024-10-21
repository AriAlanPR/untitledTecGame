import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:untitled_tec_game/extensions/nullable_extension.dart';

enum EmptyViewType {
  basic,
  nonRefreshable,
  scrollable,
}

class EmptyPage extends StatelessWidget {
  final bool showRetry;
  final String? emptyMessage;
  final EmptyViewType type;
  /// Callback function to execute when clicking the refresh button
  final void Function()? refreshFunction;

  const EmptyPage({
    super.key,
    required this.refreshFunction,
    this.emptyMessage,
    this.type = EmptyViewType.basic,
    this.showRetry = true,
  });

  const EmptyPage.nonRefreshable({
    super.key,
    this.emptyMessage,
  }): type = EmptyViewType.nonRefreshable, 
    refreshFunction = null,
    showRetry = false;

  double _height(BuildContext context) => MediaQuery.of(context).size.height;

  Widget _basic(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if(EmptyViewType.scrollable == type) SizedBox(
          height: _height(context) * 0.2,
        ),
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
              Text('retry'.i18n()),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: !(type == EmptyViewType.scrollable) ? double.infinity : null,
      height: !(type == EmptyViewType.scrollable) ? double.infinity : null,
      color: Colors.white.withOpacity(0.5),
      child: type == EmptyViewType.scrollable ? SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: _basic(context),
      ) : _basic(context),
    );
  }
}