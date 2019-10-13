import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/screens/information_parser.screen.dart';
import 'package:prep/utils/backend_provider.dart';
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

  testWidgets('Article should display correctly and contain the given data',
      (WidgetTester tester) async {
    List<Map<String, dynamic>> maps = new List();

    maps.add({'description': '<p>hello</p>', 'name': 'This is the name'});

    Stream<Map<String, dynamic>> mapStream = Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.informationSnapshots("dummyDocumentID"))
        .thenAnswer((_) => mapStream);

    InformationParser informationParser =
        InformationParser("dummyDocumentID", "dummyArticleName");

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: informationParser));
    await tester.pump(Duration.zero);

    final articleFinder = find.byKey(Key('articleText'));

    expect(articleFinder, findsOneWidget);
  });

  testWidgets(
      'Empty article place holder should be displayed as the article body is empty',
      (WidgetTester tester) async {
    List<Map<String, dynamic>> maps = new List();

    maps.add({'description': '', 'name': 'This is the name'});

    Stream<Map<String, dynamic>> mapStream = Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.informationSnapshots("dummyDocumentID"))
        .thenAnswer((_) => mapStream);

    InformationParser informationParser =
        InformationParser("dummyDocumentID", "dummyArticleName");

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: informationParser));
    await tester.pump(Duration.zero);

    final articleFinder = find.byKey(Key('articleText'));
    final emptyPlaceHolderFinder = find.byType(EmptyScreenPlaceholder);

    expect(articleFinder, findsNothing);
    expect(emptyPlaceHolderFinder, findsOneWidget);
  });

  testWidgets(
      'Empty article place holder should be displayed as the article body is null',
      (WidgetTester tester) async {
    List<Map<String, dynamic>> maps = new List();

    maps.add({'name': 'This is the name'});

    Stream<Map<String, dynamic>> mapStream = Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.informationSnapshots("dummyDocumentID"))
        .thenAnswer((_) => mapStream);

    InformationParser informationParser =
        InformationParser("dummyDocumentID", "dummyArticleName");

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: informationParser));
    await tester.pump(Duration.zero);

    final articleFinder = find.byKey(Key('articleText'));
    final emptyPlaceHolderFinder = find.byType(EmptyScreenPlaceholder);

    expect(articleFinder, findsNothing);
    expect(emptyPlaceHolderFinder, findsOneWidget);
  });

  testWidgets(
      'Loading progress indicator displays while the data from the stream arrives',
      (WidgetTester tester) async {
    List<Map<String, dynamic>> maps = new List();

    maps.add({'description': '<p>hello</p>', 'name': 'This is the name'});

    Stream<Map<String, dynamic>> mapStream = Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.informationSnapshots("dummyDocumentID"))
        .thenAnswer((_) => mapStream);

    InformationParser informationParser =
        InformationParser("dummyDocumentID", "dummyArticleName");

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: informationParser));

    final progressIndicatorFinder = find.byType(LinearProgressIndicator);

    expect(progressIndicatorFinder, findsOneWidget);
  });
}
