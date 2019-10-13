import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

import 'package:prep/widgets/faq_parser/faq_expansion_tile.dart';
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

  testWidgets('Expansion tile is not expanded and only shows question',
      (WidgetTester tester) async {
    FaqExpansionTile faqExpansionTile = FaqExpansionTile('Q', 'A', true, true);

    await tester.pumpWidget(testableWidget(child: faqExpansionTile));

    expect(find.text('Q'), findsOneWidget);
    expect(find.text('A'), findsNothing);
    expect(find.byKey(Key('chatButton')), findsNothing);
    expect(find.byKey(Key('infoButton')), findsNothing);
  });

  testWidgets('Expansion tile is expanded and shows question and answer',
      (WidgetTester tester) async {
    FaqExpansionTile faqExpansionTile =
        FaqExpansionTile('Q', 'A', false, false);

    await tester.pumpWidget(testableWidget(child: faqExpansionTile));

    expect(find.byKey(Key('expandableTile')), findsOneWidget);

    await tester.tap(find.text('Q'));
    await tester.pump();

    expect(find.text('Q'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.byKey(Key('chatButton')), findsNothing);
    expect(find.byKey(Key('infoButton')), findsNothing);
  });

  testWidgets(
      'Expansion tile is expanded and shows question, andwer and both shortcut buttons',
      (WidgetTester tester) async {
    FaqExpansionTile faqExpansionTile = FaqExpansionTile('Q', 'A', true, true);

    await tester.pumpWidget(testableWidget(child: faqExpansionTile));

    expect(find.byKey(Key('expandableTile')), findsOneWidget);

    await tester.tap(find.text('Q'));
    await tester.pump();

    expect(find.text('Q'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.byKey(Key('chatButton')), findsOneWidget);
    expect(find.byKey(Key('infoButton')), findsOneWidget);
  });

  testWidgets('Tapping on the information shortcut button navigates to the preparation tab screen', (WidgetTester tester) async {
    FaqExpansionTile faqExpansionTile = FaqExpansionTile('Q', 'A', true, true);

    MockBackend mockBackend = MockBackend();

    when(mockBackend.appointmentName).thenReturn("sample appointment name");
    when(mockBackend.messagesSnapshots(any)).thenAnswer(null);
    when(mockBackend.prepCardsSnapshots).thenAnswer(null);

    await tester.pumpWidget(testableWidget(backend: mockBackend, child: faqExpansionTile));

    await tester.tap(find.text('Q'));
    await tester.pump();

    final infoButtonFinder = find.byKey(Key('infoButton'));

    expect(infoButtonFinder, findsOneWidget);

    await tester.tap(infoButtonFinder);
    await tester.pumpAndSettle();

    // expect(find.byKey(Key('appointmentPrepScreen')), findsOneWidget);
  });

  testWidgets('Tapping on the chat shortcut button navigates to the Dr. Chat tab screen', (WidgetTester tester) async {
    FaqExpansionTile faqExpansionTile = FaqExpansionTile('Q', 'A', true, true);

    MockBackend mockBackend = MockBackend();

    when(mockBackend.appointmentName).thenReturn("sample appointment name");
    when(mockBackend.messagesSnapshots(any)).thenAnswer(null);
    when(mockBackend.prepCardsSnapshots).thenAnswer(null);
    when(mockBackend.messagesSnapshots(any)).thenAnswer(null);
    when(mockBackend.appointmentID).thenAnswer(null);

    await tester.pumpWidget(testableWidget(backend: mockBackend, child: faqExpansionTile));

    await tester.tap(find.text('Q'));
    await tester.pump();

    final chatButtonFinder = find.byKey(Key('chatButton'));

    expect(chatButtonFinder, findsOneWidget);

    await tester.tap(chatButtonFinder);
    await tester.pumpAndSettle();
  });
}
