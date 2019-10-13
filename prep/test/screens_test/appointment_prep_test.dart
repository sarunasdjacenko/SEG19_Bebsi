import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep/utils/backend.dart';
import 'package:prep/screens/appointment_prep.screen.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
      "Having a stream of one article causes the widget to display a staggered grid with only one card, the article card",
      (WidgetTester tester) async {
    List<List<Map<String, Map<String, dynamic>>>> maps = new List();

    maps.add([
      {
        'sampleDocID': {
          'description': '<h1>Hello this is the description</h1>',
          'title': 'The hello article',
          'type': 'article'
        }
      }
    ]);

    Stream<List<Map<String, Map<String, dynamic>>>> mapStream =
        Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.prepCardsSnapshots).thenAnswer((_) => mapStream);

    AppointmentPrep appointmentPrep = AppointmentPrep();

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: appointmentPrep));
    await tester.pump(Duration.zero);

    final gridFinder = find.byType(StaggeredGridView);
    final cardList = ((gridFinder.evaluate().single.widget as StaggeredGridView)
            .childrenDelegate as SliverChildBuilderDelegate)
        .childCount;
    final articleCardFinder = find.text('The hello article');

    expect(gridFinder, findsOneWidget);
    expect(cardList, 1);
    expect(articleCardFinder, findsOneWidget);
  });

  testWidgets(
      "A stream with 1 card of each category displays a grid with 4 cards, each displaying the given title",
      (WidgetTester tester) async {
    List<List<Map<String, Map<String, dynamic>>>> maps = new List();

    maps.add([
      {
        'sampleDocID0': {
          'description': '<h1>Hello this is the description</h1>',
          'title': 'The hello article',
          'type': 'article'
        }
      },
      {
        'sampleDocID1': {
          'contents': "Not allowed foods",
          'maps': [
            {
              'descriptions': 'sample description',
              'list': ['salt', 'papper']
            }
          ],
          'title': 'Not allowed foods',
          'type': 'categoryList'
        }
      },
      {
        'sampleDocID2': {
          'question': 'sample question',
          'answer': 'sample answer',
          'informationShortcut': true,
          'chatShortcut': true,
          'type': 'faqs'
        }
      },
      {
        'sampleDocID3': {
          'backgroundImage': "sample image url",
          'type': 'recipe',
          'title': 'scrambled Eggs'
        }
      }
    ]);

    Stream<List<Map<String, Map<String, dynamic>>>> mapStream =
        Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.prepCardsSnapshots).thenAnswer((_) => mapStream);

    AppointmentPrep appointmentPrep = AppointmentPrep();

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: appointmentPrep));
    await tester.pump(Duration.zero);

    final gridFinder = find.byType(StaggeredGridView);
    final cardList = ((gridFinder.evaluate().single.widget as StaggeredGridView)
            .childrenDelegate as SliverChildBuilderDelegate)
        .childCount;
    final articleCardFinder = find.text('The hello article');
    final faqCardFinder = find.text('Frequently Asked Questions');
    final categoryListCardFinder = find.text('Not allowed foods');
    final recipeCardFinder = find.text('Suggested Recipes');

    expect(gridFinder, findsOneWidget);
    expect(cardList, 4);
    expect(articleCardFinder, findsOneWidget);
    expect(faqCardFinder, findsOneWidget);
    expect(categoryListCardFinder, findsOneWidget);
    expect(recipeCardFinder, findsOneWidget);
  });

  testWidgets(
      "A stream 2 FAQ recods and 2 recipe records displays a grid with onle 1 FAQ card and 1 recipe card",
      (WidgetTester tester) async {
    List<List<Map<String, Map<String, dynamic>>>> maps = new List();

    maps.add([
      {
        'sampleDocID0': {
          'description': '<h1>Hello this is the description</h1>',
          'title': 'The hello article',
          'type': 'article'
        }
      },
      {
        'sampleDocID1': {
          'contents': "Not allowed foods",
          'maps': [
            {
              'descriptions': 'sample description',
              'list': ['salt', 'papper']
            }
          ],
          'title': 'Not allowed foods',
          'type': 'categoryList'
        }
      },
      {
        'sampleDocID2': {
          'question': 'sample question',
          'answer': 'sample answer',
          'informationShortcut': true,
          'chatShortcut': true,
          'type': 'faqs'
        }
      },
      {
        'sampleDocID3': {
          'backgroundImage': "sample image url",
          'type': 'recipe',
          'title': 'scrambled Eggs'
        }
      },
      {
        'sampleDocID4': {
          'question': 'sample question',
          'answer': 'sample answer',
          'informationShortcut': true,
          'chatShortcut': true,
          'type': 'faqs'
        }
      },
      {
        'sampleDocID5': {
          'backgroundImage': "sample image url",
          'type': 'recipe',
          'title': 'scrambled Eggs'
        }
      }
    ]);

    Stream<List<Map<String, Map<String, dynamic>>>> mapStream =
        Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.prepCardsSnapshots).thenAnswer((_) => mapStream);

    AppointmentPrep appointmentPrep = AppointmentPrep();

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: appointmentPrep));
    await tester.pump(Duration.zero);

    final gridFinder = find.byType(StaggeredGridView);
    final cardList = ((gridFinder.evaluate().single.widget as StaggeredGridView)
            .childrenDelegate as SliverChildBuilderDelegate)
        .childCount;
    final articleCardFinder = find.text('The hello article');
    final faqCardFinder = find.text('Frequently Asked Questions');
    final categoryListCardFinder = find.text('Not allowed foods');
    final recipeCardFinder = find.text('Suggested Recipes');

    expect(gridFinder, findsOneWidget);
    expect(cardList, 6);
    expect(articleCardFinder, findsOneWidget);
    expect(faqCardFinder, findsOneWidget);
    expect(categoryListCardFinder, findsOneWidget);
    expect(recipeCardFinder, findsOneWidget);
  });

  testWidgets(
      "An empty stream causes the empty screen placeholder to be displayed by itself",
      (WidgetTester tester) async {
    List<List<Map<String, Map<String, dynamic>>>> maps = new List();

    maps.add([]);

    Stream<List<Map<String, Map<String, dynamic>>>> mapStream =
        Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.prepCardsSnapshots).thenAnswer((_) => mapStream);

    AppointmentPrep appointmentPrep = AppointmentPrep();

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: appointmentPrep));
    await tester.pump(Duration.zero);

    final gridFinder = find.byType(StaggeredGridView);
    final articleCardFinder = find.text('The hello article');
    final emptyScreenPlaceholder = find.byType(EmptyScreenPlaceholder);

    expect(gridFinder, findsNothing);
    expect(articleCardFinder, findsNothing);
    expect(emptyScreenPlaceholder, findsOneWidget);
  });

  testWidgets(
      "The loading progress indicator is displayed by itself while the stream is arriving",
      (WidgetTester tester) async {
    List<List<Map<String, Map<String, dynamic>>>> maps = new List();

    maps.add([]);

    Stream<List<Map<String, Map<String, dynamic>>>> mapStream =
        Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.prepCardsSnapshots).thenAnswer((_) => mapStream);

    AppointmentPrep appointmentPrep = AppointmentPrep();

    await tester.pumpWidget(
        testableWidget(backend: mockBackend, child: appointmentPrep));

    final gridFinder = find.byType(StaggeredGridView);
    final articleCardFinder = find.text('The hello article');
    final linearProgressIndicator = find.byType(LinearProgressIndicator);

    expect(gridFinder, findsNothing);
    expect(articleCardFinder, findsNothing);
    expect(linearProgressIndicator, findsOneWidget);
  });
}
