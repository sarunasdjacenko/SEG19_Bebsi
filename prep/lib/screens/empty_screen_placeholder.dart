import 'package:flutter/material.dart';

import 'package:prep/utils/misc_functions.dart';

/// A widget used for displaying when a page's contents are empty. It contains
/// a title and a subtitle.
class EmptyScreenPlaceholder extends StatelessWidget {
  final String title;
  final String subtitle;

  EmptyScreenPlaceholder(this.title, this.subtitle);

  /// Builds the widget and applies simple formatting to the title and subtitle
  /// texts. The title becomes bold and all elements are centered and greyed out
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            stringValidator(title),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        Padding(
          key: Key('padding'),
          padding: EdgeInsets.all(20.0),
        ),
          Text(
            stringValidator(subtitle),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.grey,
            ),
          ),
        ],
      )
    );
  }
}