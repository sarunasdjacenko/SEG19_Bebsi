import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:prep/utils/backend_provider.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/widgets/appointment_info/appointment_banner.dart';
import 'package:prep/utils/misc_functions.dart';

/// This widget is the first and default tab of the appointment bottom
/// navigation bar. It displays an appointment banner followed by an article
/// in a column layout.
class AppointmentInfo extends StatelessWidget {

  /// Retrieves the article in HTML format, parses it and displays it.
  Widget _buildArticle(BuildContext context, Map<String, dynamic> dataMap) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Html(
            key: Key('articleText'),
            data: dataMap['description'],
            useRichText: true,
            //turn this off to get the alternative parser
            onLinkTap: (url) {
              launchURL(url);
            },
            customRender: null,
          ),
        ));
  }

  /// Places the banner and article inside a scrollable component. A linear
  /// progress indicator is displayed while Stream is arriving. If the article
  /// data is null or empty, an empty screen placeholder is displayed instead.
  @override
  Widget build(BuildContext context) {
    return ListView(
      key: Key('appointmentInfoScreen'),
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        AppointmentDetailsBanner(),
        StreamBuilder(
            stream: BackendProvider.of(context).backend.testSnapshots,
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
                  return Container(
                      padding: EdgeInsets.only(top: 50.0),
                      child: EmptyScreenPlaceholder(
                          "This article contains no more information", ""));
                }
              }
            }),
      ],
    );
  }
}
