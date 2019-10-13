import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/widgets/dashboard/calendar.dart';
import 'package:prep/widgets/dashboard/calendar_card.dart';
import 'package:prep/widgets/dashboard/calendar_label.dart';

void main() {
  Widget testableWidget({Widget child}) {
    return MaterialApp(
        home: child,
    );
  }

  List<Map<String, Map<String, dynamic>>> maps = new List();

  // sampleID1 takes place in the current day
  maps.add({
    'sampleID1': {
      'contactNumber': '123456789',
      'datetime': Timestamp.fromDate(DateTime.now()),
      'doctor': 'Medicine Pillz',
      'expired': false,
      'location': "St. Thomas Hospital",
      'staffMember': 'sampleStaffMemberCode',
      'testID': 'sampleTestID',
      'testName': 'FDG PET Scan of the Heart',
      'used': false
    }
  });

  // sampleID2 is the day after
  maps.add({
    'sampleID2': {
      'contactNumber': '123456789',
      'datetime': Timestamp.fromDate(DateTime.now().add(Duration(days: 1))),
      'doctor': 'Medicine Pillz',
      'expired': false,
      'location': "St. Thomas Hospital",
      'staffMember': 'sampleStaffMemberCode',
      'testID': 'sampleTestID',
      'testName': 'FDG PET Scan of the Heart',
      'used': false
    }
  });

  testWidgets("2 calendar cards and 2 calendar labels are displayed given the dataset", (WidgetTester tester) async {
    Calendar calendar = Calendar("sampleID1,sampleID2", maps);

    await tester.pumpWidget(testableWidget(child: calendar));
    await tester.pump();

    final calendarCardFinder = find.byType(CalendarCard);
    final calendarLabelFinder = find.byType(CalendarLabel);

    expect(calendarCardFinder, findsNWidgets(2));
    expect(calendarLabelFinder, findsNWidgets(2));
  });

  testWidgets("2 calendar cards and 1 calendar label are displayed given the dataset", (WidgetTester tester) async {
    List<Map<String, Map<String, dynamic>>> maps = new List();

    // sampleID1 takes place in the current day
    maps.add({
      'sampleID1': {
        'contactNumber': '123456789',
        'datetime': Timestamp.fromDate(DateTime.now()),
        'doctor': 'Medicine Pillz',
        'expired': false,
        'location': "St. Thomas Hospital",
        'staffMember': 'sampleStaffMemberCode',
        'testID': 'sampleTestID',
        'testName': 'FDG PET Scan of the Heart',
        'used': false
      }
    });

    // sampleID2 is the day after
    maps.add({
      'sampleID2': {
        'contactNumber': '123456789',
        'datetime': Timestamp.fromDate(DateTime.now()),
        'doctor': 'Medicine Pillz',
        'expired': false,
        'location': "St. Thomas Hospital",
        'staffMember': 'sampleStaffMemberCode',
        'testID': 'sampleTestID',
        'testName': 'FDG PET Scan of the Heart',
        'used': false
      }
    });

    Calendar calendar = Calendar("sampleID1,sampleID2", maps);

    await tester.pumpWidget(testableWidget(child: calendar));
    await tester.pump();

    final calendarCardFinder = find.byType(CalendarCard);
    final calendarLabelFinder = find.byType(CalendarLabel);

    expect(calendarCardFinder, findsNWidgets(2));
    expect(calendarLabelFinder, findsNWidgets(1));
  });
}