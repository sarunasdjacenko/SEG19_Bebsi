import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/screens/daily_checkups.screen.dart';
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

  testWidgets(
      "The title and icon of the checkup are formatted correctly when daysBeforeTest is greater than 1",
      (WidgetTester tester) async {
    List<List<Map<String, Map<String, dynamic>>>> maps = new List();

    maps.add([
      {
        'sampleID': {
          'daysBeforeTest': 2,
          'description': 'sample description 2',
          'instructions': {
            '0': {
              'answer': false,
              'lastChecked': 'sometime',
              'question': 'sampleQuestion 1'
            },
            '1': {
              'answer': true,
              'lastChecked': 'sometime',
              'question': 'sampleQuestion 2'
            }
          },
          'title': 'id2'
        }
      }
    ]);

    Stream<List<Map<String, Map<String, dynamic>>>> mapStream =
        Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.dailyCheckupsSnapshots).thenAnswer((_) => mapStream);
    when(mockBackend.dateTime)
        .thenReturn(Timestamp(1553004682, 424000000).toDate());

    DailyCheckups dailyCheckups = DailyCheckups();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: dailyCheckups));
    await tester.pump(Duration.zero);

    final chcekupTitleFinder = find.text("2 days to your appointment");
    final monthAbreviationFinder = find.text('Mar');
    final dateFinder = find.text(Timestamp(1553004682, 424000000)
        .toDate()
        .subtract(Duration(days: 2))
        .day
        .toString());
    final dateIconFinder = find.byKey(Key('dateIcon'));

    expect(
        (dateIconFinder.evaluate().single.widget as CircleAvatar)
            .backgroundColor,
        Colors.indigo[400]);
    expect(chcekupTitleFinder, findsOneWidget);
    expect(monthAbreviationFinder, findsOneWidget);
    expect(dateFinder, findsOneWidget);
  });

  testWidgets(
      "The title and icon of the checkup are formatted correctly when daysBeforeTest is 1",
      (WidgetTester tester) async {
    List<List<Map<String, Map<String, dynamic>>>> maps = new List();

    maps.add([
      {
        'sampleID': {
          'daysBeforeTest': 1,
          'description': 'sample description 2',
          'instructions': {
            '0': {
              'answer': false,
              'lastChecked': 'sometime',
              'question': 'sampleQuestion 1'
            },
            '1': {
              'answer': true,
              'lastChecked': 'sometime',
              'question': 'sampleQuestion 2'
            }
          },
          'title': 'id2'
        }
      }
    ]);

    Stream<List<Map<String, Map<String, dynamic>>>> mapStream =
        Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.dailyCheckupsSnapshots).thenAnswer((_) => mapStream);
    when(mockBackend.dateTime)
        .thenReturn(Timestamp(1553004682, 424000000).toDate());

    DailyCheckups dailyCheckups = DailyCheckups();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: dailyCheckups));
    await tester.pump(Duration.zero);

    final chcekupTitleFinder = find.text("Your appointment is tomorrow");
    final monthAbreviationFinder = find.text('Mar');
    final dateFinder = find.text(Timestamp(1553004682, 424000000)
        .toDate()
        .subtract(Duration(days: 1))
        .day
        .toString());
    final dateIconFinder = find.byKey(Key('dateIcon'));

    expect(
        (dateIconFinder.evaluate().single.widget as CircleAvatar)
            .backgroundColor,
        Colors.indigo[400]);
    expect(chcekupTitleFinder, findsOneWidget);
    expect(monthAbreviationFinder, findsOneWidget);
    expect(dateFinder, findsOneWidget);
  });

  testWidgets(
      "The title and icon of the checkup are formatted correctly when daysBeforeTest is 0",
      (WidgetTester tester) async {
    List<List<Map<String, Map<String, dynamic>>>> maps = new List();

    maps.add([
      {
        'sampleID': {
          'daysBeforeTest': 0,
          'description': 'sample description 2',
          'instructions': {
            '0': {
              'answer': false,
              'lastChecked': 'sometime',
              'question': 'sampleQuestion 1'
            },
            '1': {
              'answer': true,
              'lastChecked': 'sometime',
              'question': 'sampleQuestion 2'
            }
          },
          'title': 'id2'
        }
      }
    ]);

    Stream<List<Map<String, Map<String, dynamic>>>> mapStream =
        Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.dailyCheckupsSnapshots).thenAnswer((_) => mapStream);
    when(mockBackend.dateTime)
        .thenReturn(Timestamp(1553004682, 424000000).toDate());

    DailyCheckups dailyCheckups = DailyCheckups();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: dailyCheckups));
    await tester.pump(Duration.zero);

    final chcekupTitleFinder = find.text("Your appointment is today!");

    final monthAbreviationFinder = find.text('Mar');
    final dateFinder = find.text(Timestamp(1553004682, 424000000)
        .toDate()
        .subtract(Duration(days: 0))
        .day
        .toString());
    final dateIconFinder = find.byKey(Key('dateIcon'));

    expect(
        (dateIconFinder.evaluate().single.widget as CircleAvatar)
            .backgroundColor,
        Colors.red[400]);
    expect(chcekupTitleFinder, findsOneWidget);
    expect(monthAbreviationFinder, findsOneWidget);
    expect(dateFinder, findsOneWidget);
  });

  testWidgets(
      "Exactly the number of instructions (2) given in the data are displayed in the checkups list",
      (WidgetTester tester) async {
    List<List<Map<String, Map<String, dynamic>>>> maps = new List();

    maps.add([
      {
        'sampleID': {
          'daysBeforeTest': 0,
          'description': 'sample description 2',
          'instructions': {
            '0': {
              'answer': false,
              'lastChecked': 'sometime',
              'question': 'sampleQuestion 1'
            },
            '1': {
              'answer': true,
              'lastChecked': 'sometime',
              'question': 'sampleQuestion 2'
            }
          },
          'title': 'id2'
        }
      }
    ]);

    Stream<List<Map<String, Map<String, dynamic>>>> mapStream =
        Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.dailyCheckupsSnapshots).thenAnswer((_) => mapStream);
    when(mockBackend.dateTime)
        .thenReturn(Timestamp(1553004682, 424000000).toDate());

    DailyCheckups dailyCheckups = DailyCheckups();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: dailyCheckups));
    await tester.pump(Duration.zero);

    final checkupsListFinder = find.byType(ExpansionTile);
    final checkupsListsize =
        (checkupsListFinder.evaluate().single.widget as ExpansionTile)
            .children
            .length;

    expect(checkupsListFinder, findsOneWidget);
    // This +1 is needed because a divider is always added to the list for cosmetic purposes
    expect(checkupsListsize, 2 + 1);
  });

  testWidgets("The switches in the checkups can be tapped",
      (WidgetTester tester) async {
    List<List<Map<String, Map<String, dynamic>>>> maps = new List();

    maps.add([
      {
        'sampleID': {
          'daysBeforeTest': 0,
          'description': 'sample description 2',
          'instructions': {
            '0': {
              'answer': false,
              'lastChecked': 'sometime',
              'question': 'sampleQuestion 1'
            }
          },
          'title': 'id2'
        }
      }
    ]);

    Stream<List<Map<String, Map<String, dynamic>>>> mapStream =
        Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.dailyCheckupsSnapshots).thenAnswer((_) => mapStream);
    when(mockBackend.dateTime)
        .thenReturn(Timestamp(1553004682, 424000000).toDate());
    when(mockBackend.flickCheckupSwitch('id2', '0', false)).thenReturn({});

    DailyCheckups dailyCheckups = DailyCheckups();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: dailyCheckups));
    await tester.pump(Duration.zero);

    await tester.tap(find.byType(Switch));
  });

  testWidgets("An empty screen placeholder is displayed if no data is given",
      (WidgetTester tester) async {
    List<List<Map<String, Map<String, dynamic>>>> maps = new List();

    maps.add([]);

    Stream<List<Map<String, Map<String, dynamic>>>> mapStream =
        Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.dailyCheckupsSnapshots).thenAnswer((_) => mapStream);
    when(mockBackend.dateTime)
        .thenReturn(Timestamp(1553004682, 424000000).toDate());

    DailyCheckups dailyCheckups = DailyCheckups();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: dailyCheckups));
    await tester.pump(Duration.zero);

    final emptyScreenPlaceHolderFinder = find.byType(EmptyScreenPlaceholder);
    expect(emptyScreenPlaceHolderFinder, findsOneWidget);
  });

  testWidgets("Progress indicator is displayed while the stream arrives",
      (WidgetTester tester) async {
    List<List<Map<String, Map<String, dynamic>>>> maps = new List();

    maps.add([]);

    Stream<List<Map<String, Map<String, dynamic>>>> mapStream =
        Stream.fromIterable(maps);

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.dailyCheckupsSnapshots).thenAnswer((_) => mapStream);
    when(mockBackend.dateTime)
        .thenReturn(Timestamp(1553004682, 424000000).toDate());

    DailyCheckups dailyCheckups = DailyCheckups();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: dailyCheckups));

    final progressIndicatorFinder = find.byType(LinearProgressIndicator);
    expect(progressIndicatorFinder, findsOneWidget);
  });
}
