import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:untitled_tec_game/utils/log_handler.dart';
import 'package:untitled_tec_game/widgets/empty.dart';

class WidgetAsincrono<T> extends StatelessWidget {
  ///function that fetches the data to be displayed
  final Future<T> Function() fetchFunction;
  ///widget that displays when the response is successful
  final Widget Function(T) responseWidget;
  ///setState function of the parent, used to refresh at the parent widget level
  final void Function(void Function() fn)? setParentState;
  final bool handleEmptyResults;

  const WidgetAsincrono({
    super.key, 
    required this.fetchFunction, 
    required this.responseWidget, 
    this.setParentState,
    this.handleEmptyResults = false,
  });

  /// Returns a widget displaying a loading view with a spinner.
  /// 
  /// The container centers its child widget, which is a TechWidgets.techSpinner.
  Widget _loadingView() => Container(
    color: Colors.white.withOpacity(0.6),
    child: Center(
      child: LoadingAnimationWidget.bouncingBall(color: Colors.orange, size: 50),
    ),
  );

  /// Returns an EmptyPage widget with a refresh function that calls the setParentState function if it is not null.
  /// 
  /// A refresh function is called when the user wants to refresh the empty page.
  /// 
  /// Returns:
  ///   A Widget representing the empty page.
  Widget _emptyView({String? emptyMessage}) => EmptyPage(
    emptyMessage: emptyMessage,
    refreshFunction: () {
      if(setParentState != null) {
        setParentState!(() {});
      }
    },
  );

  bool _isEmptyList(T? response) {
    if(response is List) {
      return (response as List).isEmpty;
    } 

    return true;
  }

  bool _isEmptyMap(T? response) {
    if(response is Map) {
      return (response as Map).isEmpty;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: fetchFunction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) { //is loading data
          return _loadingView();
        } else if (snapshot.hasError) { //error occurred
          printerr(snapshot.error!, snapshot.stackTrace);
          return _emptyView(emptyMessage: "unexpected_error");
          //else if the response result has no data or there is empty data and this widget is to handle empty results, show the empty view
        } else if (!snapshot.hasData || (handleEmptyResults && (_isEmptyList(snapshot.data) || _isEmptyMap(snapshot.data)))) {
          return _emptyView(); //didn't get any data
        } else { //got data
          try {
            //get the response data
            final response = snapshot.data;
            //make sure the response is not null, throw an error if it is to force show of an empty view
            if(response != null) {
              return responseWidget(response);
            } else {
              throw Exception('Null response');
            }
          } catch (e, s) {
            printerr(e, s);
            return _emptyView();
          }
        }
      },
    );
  }
}