import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/screens/faq_parser.screen.dart';
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

  testWidgets("The cards are unexpanded by default and only show the question", (WidgetTester tester) async {
    List<List<Map<String, dynamic>>> maps = new List();

    maps.add([
      {
        'question': 'question 1',
        'answer': 'answer 1',
        'informationShortcut': true,
        'chatShortcut': true
      }
    ]);

    Stream<List<Map<String, dynamic>>> mapStream = Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.faqSnapshots).thenAnswer((_) => mapStream);

    FaqParser faqParser = FaqParser();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: faqParser));
    await tester.pump(Duration.zero);

    final cardQuestionFinder = find.text('question 1');
    final answerFinder = find.text('answer 1');

    expect(cardQuestionFinder, findsOneWidget);
    expect(answerFinder, findsNothing);
  });

  testWidgets("The cards are expanded when tapped and then show the question as well as the asnwer and no shortcuts", (WidgetTester tester) async {
    List<List<Map<String, dynamic>>> maps = new List();

    maps.add([
      {
        'question': 'question 1',
        'answer': 'answer 1',
        'informationShortcut': false,
        'chatShortcut': false
      }
    ]);

    Stream<List<Map<String, dynamic>>> mapStream = Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.faqSnapshots).thenAnswer((_) => mapStream);

    FaqParser faqParser = FaqParser();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: faqParser));
    await tester.pump(Duration.zero);

    final cardQuestionFinder = find.text('question 1');

    await tester.tap(cardQuestionFinder);

    await tester.pump();

    final answerFinder = find.text('answer 1');

    final chatButtonFinder = find.byKey(Key('chatButton'));
    final infoButtonFinder = find.byKey(Key('infoButton'));

    expect(cardQuestionFinder, findsOneWidget);
    expect(answerFinder, findsOneWidget);
    expect(chatButtonFinder, findsNothing);
    expect(infoButtonFinder, findsNothing);
  });

  testWidgets("The cards are expanded when tapped and then show the question as well as the asnwer and both shortcuts", (WidgetTester tester) async {
    List<List<Map<String, dynamic>>> maps = new List();

    maps.add([
      {
        'question': 'question 1',
        'answer': 'answer 1',
        'informationShortcut': true,
        'chatShortcut': true
      }
    ]);

    Stream<List<Map<String, dynamic>>> mapStream = Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.faqSnapshots).thenAnswer((_) => mapStream);

    FaqParser faqParser = FaqParser();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: faqParser));
    await tester.pump(Duration.zero);

    final cardQuestionFinder = find.text('question 1');

    await tester.tap(cardQuestionFinder);

    await tester.pump();

    final answerFinder = find.text('answer 1');

    final chatButtonFinder = find.byKey(Key('chatButton'));
    final infoButtonFinder = find.byKey(Key('infoButton'));

    expect(cardQuestionFinder, findsOneWidget);
    expect(answerFinder, findsOneWidget);
    expect(chatButtonFinder, findsOneWidget);
    expect(infoButtonFinder, findsOneWidget);
  });

  testWidgets("The empty place holder is displayed when an empty stream is sent", (WidgetTester tester) async {
    List<List<Map<String, dynamic>>> maps = new List();

    maps.add([]);

    Stream<List<Map<String, dynamic>>> mapStream = Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.faqSnapshots).thenAnswer((_) => mapStream);

    FaqParser faqParser = FaqParser();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: faqParser));
    await tester.pump(Duration.zero);

    final cardQuestionFinder = find.text('question 1');
    final emptyScreenPlaceholder = find.byType(EmptyScreenPlaceholder);

    expect(cardQuestionFinder, findsNothing);
    expect(emptyScreenPlaceholder, findsOneWidget);
  });

  testWidgets("The progress indicator is displayed when the stream is arriving", (WidgetTester tester) async {
    List<List<Map<String, dynamic>>> maps = new List();

    maps.add([]);

    Stream<List<Map<String, dynamic>>> mapStream = Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.faqSnapshots).thenAnswer((_) => mapStream);

    FaqParser faqParser = FaqParser();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: faqParser));

    final cardQuestionFinder = find.text('question 1');
    final emptyScreenPlaceholderFinder = find.byType(EmptyScreenPlaceholder);
    final progresIndicatorFinder = find.byType(LinearProgressIndicator);

    expect(cardQuestionFinder, findsNothing);
    expect(emptyScreenPlaceholderFinder, findsNothing);
    expect(progresIndicatorFinder, findsOneWidget);
  });
}
