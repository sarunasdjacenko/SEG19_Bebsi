import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/utils/misc_functions.dart';
import 'package:prep/widgets/appointment_info/appointment_banner.dart';
import 'package:prep/utils/backend_provider.dart';

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
      "Appointment banner should contain all 4 correct text widgets and the correct color",
      (WidgetTester tester) async {
    MockBackend mockBackend = new MockBackend();

    when(mockBackend.location).thenReturn("appLocation");
    when(mockBackend.dateTime).thenReturn(DateTime(2027, 1, 1, 1, 0, 0, 0, 0));
    when(mockBackend.doctorName).thenReturn("doctorName");
    when(mockBackend.contactNumber).thenReturn("12345");
    when(mockBackend.color).thenReturn(Colors.blue);

    AppointmentDetailsBanner appointmentDetailsBanner =
        AppointmentDetailsBanner();

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: appointmentDetailsBanner));

    final rootCardWidgetFinder = find.byKey(Key('rootCard'));
    final dateTextFinder = find.text(dateFormatter(DateTime(2027, 1, 1, 1, 0, 0, 0, 0)));
    final timeTextFinder = find.text(timeFormatter(DateTime(2027, 1, 1, 1, 0, 0, 0, 0)));
    final locationTextFinder = find.text('appLocation');
    final doctorNameTextFinder = find.text('doctorName');
    final contactNumberTextFinder = find.text('12345');

    Color bannerColor =
        (rootCardWidgetFinder.evaluate().single.widget as Card).color;

    expect(rootCardWidgetFinder, findsOneWidget);
    expect(dateTextFinder, findsOneWidget);
    expect(timeTextFinder, findsOneWidget);
    expect(locationTextFinder, findsOneWidget);
    expect(doctorNameTextFinder, findsOneWidget);
    expect(contactNumberTextFinder, findsOneWidget);
    expect(bannerColor, Colors.blue);
  });

  tearDown(() => FirestoreBackend()
      .setBackendParams(null, null, null, null, null, null, null, null));
}
