import 'package:flutter_test/flutter_test.dart';
import 'package:prep/widgets/dashboard/calendar_card.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

import 'package:prep/utils/misc_functions.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/utils/backend.dart';

class MockBackend extends Mock implements FirestoreBackend {}

void main() {
  Widget testableWidget({MockBackend backend, Widget child}) {
    return BackendProvider(
      backend: backend,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets(
      'Calendar class has test name, location, staff member name, date, time and appintment code',
      (WidgetTester tester) async {
    CalendarCard calendarCard = CalendarCard(
        "hjhfuz3ey",
        "St. Thomas Hospiutal",
        DateTime(2019, 3, 25, 10, 0),
        "VyyiBYwp0xX4nJyvX9oN",
        "Eliana Reyes",
        "FDG PET Scan of the Heart",
        "12345 123456");

    await tester.pumpWidget(testableWidget(child: calendarCard));

    final appointmentTitleFinder = find.text("FDG PET Scan of the Heart");
    final location = find.text("St. Thomas Hospiutal");
    final staffMember = find.text("Eliana Reyes");
    final date = find.text(dateFormatter(DateTime(2019, 3, 25, 10, 0)));
    final time = find.text(timeFormatter(DateTime(2019, 3, 25, 10, 0)));
    final appointmentCode = find.text("hjhfuz3ey");
    final containerFinder = find.byKey(Key('rootContainer'));

    Color boxColor = ((containerFinder.evaluate().single.widget as Container)
            .decoration as BoxDecoration)
        .color;

    expect(boxColor, Colors.blue[300]);
    expect(appointmentTitleFinder, findsOneWidget);
    expect(location, findsOneWidget);
    expect(staffMember, findsOneWidget);
    expect(date, findsOneWidget);
    expect(time, findsOneWidget);
    expect(appointmentCode, findsOneWidget);
  });

  testWidgets(
      'Tapping on the card sets the values it contains in Backend and navigates to Appointment',
      (WidgetTester tester) async {
    CalendarCard calendarCard = CalendarCard(
        "hjhfuz3ey",
        "St. Thomas Hospiutal",
        DateTime(2019, 3, 25, 10, 0),
        "VyyiBYwp0xX4nJyvX9oN",
        "Eliana Reyes",
        "FDG PET Scan of the Heart",
        "12345 123456");

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.setBackendParams(any, any, any, any, any, any, any, any))
        .thenAnswer((_) {});
    when(mockBackend.appointmentName).thenReturn("sample appointment name");
    when(mockBackend.messagesSnapshots(any)).thenAnswer(null);

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: calendarCard));

    final appointmentCodeTextFinder = find.text('hjhfuz3ey');

    expect(appointmentCodeTextFinder, findsOneWidget);

    await tester.tap(appointmentCodeTextFinder);
  });
}
