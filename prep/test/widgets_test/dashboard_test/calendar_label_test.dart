import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:prep/widgets/dashboard/calendar_label.dart';
import 'package:prep/utils/misc_functions.dart';

void main() {
  Widget testableWidget({Widget child}) {
    return MaterialApp(home: child);
  }

  testWidgets('CalendarCard has correct text', (WidgetTester tester) async {
    CalendarLabel calendarLabel =
        CalendarLabel(DateTime(2019, 1, 1, 1, 0, 0, 0, 0));

    await tester.pumpWidget(testableWidget(child: calendarLabel));

    final titleFinder = find.text(
        dateFormatter(DateTime(2019, 1, 1, 1, 0, 0, 0, 0)));

    expect(titleFinder, findsOneWidget);
  });
}