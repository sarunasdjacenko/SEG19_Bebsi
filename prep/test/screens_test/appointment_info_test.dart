import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/screens/appointment_info.screen.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';

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

  MockBackend mockBackend = new MockBackend();

  when(mockBackend.appointmentID).thenReturn('hjhfuz3ey');
  when(mockBackend.testID).thenReturn('WRY7hXwJ1R7JezYC3J9w');
  when(mockBackend.appointmentName).thenReturn('FDG PET Scan of the Heart');
  when(mockBackend.location).thenReturn("St. Thomas Hospiutal");
  when(mockBackend.dateTime).thenReturn(DateTime(2019, 3, 25, 10, 0));
  when(mockBackend.doctorName).thenReturn("Eliana Reyes");
  when(mockBackend.contactNumber).thenReturn("12345");
  when(mockBackend.color).thenReturn(Colors.blue);

  testWidgets(
      'Banner and article should display correctly and contain the given data',
      (WidgetTester tester) async {
    List<Map<String, dynamic>> maps = new List();

    maps.add({'description': '<p>hello</p>', 'name': 'This is the name'});

    Stream<Map<String, dynamic>> mapStream = Stream.fromIterable(maps);

    when(mockBackend.testSnapshots).thenAnswer((_) => mapStream);

    AppointmentInfo appointmentInfo = AppointmentInfo();

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: appointmentInfo));
    await tester.pump(Duration.zero);

    final appointmentBannerBaseFinder = find.byKey(Key('rootCard'));
    final articleFinder = find.byKey(Key('articleText'));

    expect(appointmentBannerBaseFinder, findsOneWidget);
    expect(articleFinder, findsOneWidget);
  });

  testWidgets(
      'Banner displays normally but EmptyScreenPlaceholder is shown instead of article as description will have length = 0',
      (WidgetTester tester) async {
    List<Map<String, dynamic>> maps = new List();

    maps.add({'description': '', 'name': 'This is the name'});

    Stream<Map<String, dynamic>> mapStream = Stream.fromIterable(maps);

    when(mockBackend.testSnapshots).thenAnswer((_) => mapStream);

    AppointmentInfo appointmentInfo = AppointmentInfo();

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: appointmentInfo));
    await tester.pump(Duration.zero);

    final appointmentBannerBaseFinder = find.byKey(Key('rootCard'));
    final articleFinder = find.byKey(Key('articleText'));
    final emptyPlaceHolderFinder = find.byType(EmptyScreenPlaceholder);

    expect(appointmentBannerBaseFinder, findsOneWidget);
    expect(articleFinder, findsNothing);
    expect(emptyPlaceHolderFinder, findsOneWidget);
  });

  testWidgets(
      'Banner displays normally but EmptyScreenPlaceholder is shown instead of article as description will be null',
      (WidgetTester tester) async {
    List<Map<String, dynamic>> maps = new List();

    maps.add({'name': 'This is the name'});

    Stream<Map<String, dynamic>> mapStream = Stream.fromIterable(maps);

    when(mockBackend.testSnapshots).thenAnswer((_) => mapStream);

    AppointmentInfo appointmentInfo = AppointmentInfo();

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: appointmentInfo));
    await tester.pump(Duration.zero);

    final appointmentBannerBaseFinder = find.byKey(Key('rootCard'));
    final articleFinder = find.byKey(Key('articleText'));
    final emptyPlaceHolderFinder = find.byType(EmptyScreenPlaceholder);

    expect(appointmentBannerBaseFinder, findsOneWidget);
    expect(articleFinder, findsNothing);
    expect(emptyPlaceHolderFinder, findsOneWidget);
  });

  testWidgets(
      'Banner displays normally and the progress indicator is shown as the data from the stream arrives',
      (WidgetTester tester) async {
    List<Map<String, dynamic>> maps = new List();

    maps.add({'description': '<p>hello</p>', 'name': 'This is the name'});

    Stream<Map<String, dynamic>> mapStream = Stream.fromIterable(maps);

    when(mockBackend.testSnapshots).thenAnswer((_) => mapStream);

    AppointmentInfo appointmentInfo = AppointmentInfo();

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: appointmentInfo));

    final appointmentBannerBaseFinder = find.byKey(Key('rootCard'));
    final progressIndicatorFinder = find.byType(LinearProgressIndicator);

    expect(appointmentBannerBaseFinder, findsOneWidget);
    expect(progressIndicatorFinder, findsOneWidget);
  });
}
