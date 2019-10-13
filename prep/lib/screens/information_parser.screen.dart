import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:prep/utils/backend_provider.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/utils/misc_functions.dart';

/// Parses and displays an article written in HTML.
class InformationParser extends StatelessWidget {
  final String _documentId;
  final String _articleName;

  InformationParser(this._documentId, this._articleName);

  /// Parses, formats and displays an HTML article contained in the [dataMap]
  /// provided. A function is provided to handle links being tapped on.
  Widget _buildArticle(BuildContext context, Map<String, dynamic> dataMap) {
    return Container(
        child: SingleChildScrollView(
      child: Html(
        key: Key('articleText'),
        data: dataMap['description'],
        padding: EdgeInsets.all(20.0),
        useRichText: true,
        //turn this off to get the alternative parser
        onLinkTap: (url) {
          launchURL(url);
        },
        customRender: null,
      ),
    ));
  }

  /// Dynamically determines what to display based on the state of the data
  /// read form the database. If the data is valid, it will display a parsed
  /// HTML article, if it is not, it will display an empty screen placeholder.
  /// A loading indicator is shown during loading.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(stringValidator(_articleName)),
      ),
      body: StreamBuilder(
          stream: BackendProvider.of(context)
              .backend
              .informationSnapshots(_documentId),
          builder: (context, dataSnapshot) {
            if (!dataSnapshot.hasData) {
              return const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(),
              );
            } else {
              if (dataSnapshot.data['description'] != null &&
                  dataSnapshot.data['description'].length > 0) {
                return _buildArticle(context, dataSnapshot.data);
              } else {
                return EmptyScreenPlaceholder("This article is empty", "");
              }
            }
          }),
    );
  }
}
