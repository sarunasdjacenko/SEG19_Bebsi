import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

import 'package:prep/utils/backend_provider.dart';
import 'package:prep/utils/backend.dart';
import 'package:prep/screens/list_parser.screen.dart';
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

  testWidgets(
      'The page is given a complete data set and exactly 2 drop down lists are produced',
      (WidgetTester tester) async {
    List<Map<String, dynamic>> maps = new List();

    maps.add({
      'contents': "Allowed foods",
      'maps': [
        {
          'description': "Sample description",
          'list': ['item 1', 'item 2', 'item 3'],
          'name': "Sample name"
        },
        {
          'description': "Sample description 2",
          'list': ['item 1', 'item 2', 'item 3'],
          'name': "Sample name 2"
        },
      ],
      'title': "Allowed foods",
      'type': "categoryList"
    });

    Stream<Map<String, dynamic>> mapStream = Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.categoryListSnapshots("dummyDocumentID"))
        .thenAnswer((_) => mapStream);

    CategoryListParser categoryListParser =
        CategoryListParser("dummyDocumentID", "dummyTitle");

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: categoryListParser));
    await tester.pump(Duration.zero);

    final listColumnFinder = find.byKey(Key('listsColumn'));
    final List<Widget> generatedChildren =
        (listColumnFinder.evaluate().single.widget as Column).children;

    expect(listColumnFinder, findsOneWidget);
    expect(generatedChildren.length, 2);
  });

  testWidgets(
      'The page is given a complete data set and exactly 1 drop down lists are produced',
      (WidgetTester tester) async {
    List<Map<String, dynamic>> maps = new List();

    maps.add({
      'contents': "Allowed foods",
      'maps': [
        {
          'description': "Sample description",
          'list': ['item 1', 'item 2', 'item 3'],
          'name': "Sample name"
        },
      ],
      'title': "Allowed foods",
      'type': "categoryList"
    });

    Stream<Map<String, dynamic>> mapStream = Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.categoryListSnapshots("dummyDocumentID"))
        .thenAnswer((_) => mapStream);

    CategoryListParser categoryListParser =
        CategoryListParser("dummyDocumentID", "dummyTitle");

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: categoryListParser));
    await tester.pump(Duration.zero);

    final listColumnFinder = find.byKey(Key('listsColumn'));
    final List<Widget> generatedChildren =
        (listColumnFinder.evaluate().single.widget as Column).children;

    expect(listColumnFinder, findsOneWidget);
    expect(generatedChildren.length, 1);
  });

  testWidgets(
      'The page is given an empty set of lists and it displays an empty screen placeholder',
      (WidgetTester tester) async {
    List<Map<String, dynamic>> maps = new List();

    maps.add({
      'contents': "Allowed foods",
      'maps': [],
      'title': "Allowed foods",
      'type': "categoryList"
    });

    Stream<Map<String, dynamic>> mapStream = Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.categoryListSnapshots("dummyDocumentID"))
        .thenAnswer((_) => mapStream);

    CategoryListParser categoryListParser =
        CategoryListParser("dummyDocumentID", "dummyTitle");

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: categoryListParser));
    await tester.pump(Duration.zero);

    final emptyScreenPlaceholder = find.byType(EmptyScreenPlaceholder);

    expect(emptyScreenPlaceholder, findsOneWidget);
  });

  testWidgets(
      'The page is given a null list of elements and it displays an empty screen placeholder',
      (WidgetTester tester) async {
    List<Map<String, dynamic>> maps = new List();

    maps.add({
      'contents': "Allowed foods",
      'title': "Allowed foods",
      'type': "categoryList"
    });

    Stream<Map<String, dynamic>> mapStream = Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.categoryListSnapshots("dummyDocumentID"))
        .thenAnswer((_) => mapStream);

    CategoryListParser categoryListParser =
        CategoryListParser("dummyDocumentID", "dummyTitle");

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: categoryListParser));
    await tester.pump(Duration.zero);

    final emptyScreenPlaceholder = find.byType(EmptyScreenPlaceholder);

    expect(emptyScreenPlaceholder, findsOneWidget);
  });

  testWidgets('The loading indicator is active while the stream is arriving',
      (WidgetTester tester) async {
    List<Map<String, dynamic>> maps = new List();

    maps.add({
      'contents': "Allowed foods",
      'maps': [
        {
          'description': "Sample description",
          'list': ['item 1', 'item 2', 'item 3'],
          'name': "Sample name"
        },
      ],
      'title': "Allowed foods",
      'type': "categoryList"
    });

    Stream<Map<String, dynamic>> mapStream = Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.categoryListSnapshots("dummyDocumentID"))
        .thenAnswer((_) => mapStream);

    CategoryListParser categoryListParser =
        CategoryListParser("dummyDocumentID", "dummyTitle");

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: categoryListParser));

    final progressIndicator = find.byType(LinearProgressIndicator);

    expect(progressIndicator, findsOneWidget);
  });
}
