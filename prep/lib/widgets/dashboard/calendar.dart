import 'package:flutter/material.dart';

import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/widgets/dashboard/calendar_card.dart';
import 'package:prep/widgets/dashboard/calendar_label.dart';

/// Displays a calendar made of a sequence of calendar labels and calendar
/// cards.
class Calendar extends StatelessWidget {
  String codeFileState;
  List<Map<String, Map<String, dynamic>>> documentList;

  Calendar(this.codeFileState, this.documentList);

  /// Determines if a given [code] already exists in the locally stored codes
  /// file (if the appointment is already in the calendar)
  bool _documentInCodeFile(String code) {
    return codeFileState.split(',').contains(code);
  }

  /// Determines if two dates are equal based on only their date, NOT their
  /// time. It only takes into account the day, month and year components.
  bool _datesAreEqual(DateTime date1, DateTime date2) {
    return (date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year);
  }

  /// Builds the calendar widget based on the codes stored in the local codes
  /// file. If there is no data or no codes file is detected, an empty calendar
  /// place holder is returned. If two appointments happen on the same date,
  /// only one calendar label is produced for both of them, else a calendar
  /// label and calendar pair is added to the calendar for each appointment.
  @override
  Widget build(BuildContext context) {
    List<Widget> calendarElements = new List();

    if (codeFileState == null) {
      // no calendar can be built as no local code file exists
      return null;
    } else if (codeFileState.isEmpty) {
      // no calendar can be built as there is no data
      return EmptyScreenPlaceholder(
          "Your calendar is empty", "Add some appointments");
    } else {
      // Generates a list of filtered appointments
      List<Map<String, Map<String, dynamic>>> filteredDocuments = new List();

      documentList.forEach((docIdDataMap) {
        String docID = docIdDataMap.keys.first;
        if (_documentInCodeFile(docID)) {
          filteredDocuments.add(docIdDataMap);
        }
      });

      // Update the document list
      documentList = filteredDocuments;

      // Add the first calendar label and card pair to the calendar
      String element0docID = documentList.elementAt(0).keys.first;
      Map<String, dynamic> element0dataMap =
          documentList.elementAt(0)[element0docID];

      calendarElements.add(CalendarLabel(element0dataMap['datetime'].toDate()));

      calendarElements.add(CalendarCard(
          element0docID,
          element0dataMap['location'],
          element0dataMap['datetime'].toDate(),
          element0dataMap['testID'],
          element0dataMap['doctor'],
          element0dataMap['testName'],
          element0dataMap['contactNumber']));

      // Add any subsequent number of calendar labels and cards to the calendar
      for (int i = 1; i < documentList.length; i++) {
        String prevElementId = documentList.elementAt(i-1).keys.first;
        Map<String, dynamic> prevElementDataMap =
        documentList.elementAt(i-1)[prevElementId];

        String elementidocID = documentList.elementAt(i).keys.first;
        Map<String, dynamic> elementidataMap =
            documentList.elementAt(i)[elementidocID];

        if (_datesAreEqual(elementidataMap['datetime'].toDate(),
            (prevElementDataMap['datetime'].toDate()))) {
          calendarElements.add(CalendarCard(
              elementidocID,
              elementidataMap['location'],
              elementidataMap['datetime'].toDate(),
              elementidataMap['testID'],
              elementidataMap['doctor'],
              elementidataMap['testName'],
              elementidataMap['contactNumber']));
        } else {
          calendarElements
              .add(CalendarLabel(elementidataMap['datetime'].toDate()));
          calendarElements.add(CalendarCard(
              elementidocID,
              elementidataMap['location'],
              elementidataMap['datetime'].toDate(),
              elementidataMap['testID'],
              elementidataMap['doctor'],
              elementidataMap['testName'],
              elementidataMap['contactNumber']));
        }
      }

      // Place the calendar in a scrollable component before returning it
      return ListView(
        padding:
            EdgeInsets.only(top: 10.0, bottom: 80.0, left: 10.0, right: 10.0),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: calendarElements,
          )
        ],
      );
    }
  }
}
