import 'package:flutter/material.dart';

import 'package:prep/utils/backend_provider.dart';
import 'package:prep/utils/backend.dart';
import 'package:prep/utils/misc_functions.dart';

/// This widget displays appointment information in a column format. The
/// information is presented in a labeled format, ie: Date: 31 March 2019. Where
/// the label is shown above the data.
class AppointmentDetailsBanner extends StatelessWidget {

  /// Builds a card containing the appointment information and the corresponding
  /// labels. The formatter classes TitleText and SubtitleText are used to style
  /// and distinguish labels form data
  @override
  Widget build(BuildContext context) {
    final BaseBackend backend = BackendProvider.of(context).backend;

    return Card(
      key: Key('rootCard'),
      elevation: 3.0,
      color: backend.color,
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _TitleText("Date"),
            _SubtitleText(dateFormatter(backend.dateTime)),
            Divider(
              color: Colors.white,
            ),
            _TitleText("Time"),
            _SubtitleText(timeFormatter(backend.dateTime)),
            Divider(
              color: Colors.white,
            ),
            _TitleText("Location"),
            _SubtitleText(backend.location),
            Divider(
              color: Colors.white,
            ),
            _TitleText("Staff"),
            _SubtitleText(backend.doctorName),
            Divider(
              color: Colors.white,
            ),
            _TitleText("Contact Number"),
            Text(
              "Call to reschedule appointments",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
            _SubtitleText(backend.contactNumber),
          ],
        ),
      ),
    );
  }
}

/// This private class provides formatting for the 'Title' type of text.
class _TitleText extends StatelessWidget {
  final String text;
  _TitleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        stringValidator(text),
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// This private class provides formatting for the 'Subtitle' type of text.
class _SubtitleText extends StatelessWidget {
  final String text;

  _SubtitleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        stringValidator(text),
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
    );
  }
}
