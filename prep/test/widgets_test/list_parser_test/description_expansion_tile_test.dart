import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:prep/widgets/list_parser/description_expansion_tile.dart';

void main() {
  Widget testableWidget({Widget child}) {
    return MaterialApp(home: child);
  }

  testWidgets(
      'Expansion tile is not expanded on arrival and hence only title is displayed',
      (WidgetTester tester) async {
        //Makes a list of items to test in the expansion tile
    List<String> items = [
      "item1",
      "item2",
      "item3 hello",
      "item4 cars",
      "item5"
    ];
    //Makes a DescriptiveExpansioinTile object to test
    DescriptiveExpansionTile expansionTile =
        DescriptiveExpansionTile("testCategory", "testDescription", items);
      //Renders UI with expansionTile widget
    await tester.pumpWidget(testableWidget(child: expansionTile));
     //Text to search for
    final titleFinder = find.text("testCategory"); 
    final descriptionFinder = find.text("testDescription");
    final itemListFinder =
        find.text("item1 • item2 • item3 hello • item4 cars • item5");
    //Expect a widget wiht title
    expect(titleFinder, findsOneWidget); 
    //Expect no widget with description
    expect(descriptionFinder, findsNothing); 
    //Expect no widget with items
    expect(itemListFinder, findsNothing); 
  });

  testWidgets(
      'Expansion tile displays a card with a title, subtitle and description with the correct data formats after being expanded',
      (WidgetTester tester) async {
    List<String> items = [
      "item1",
      "item2",
      "item3 hello",
      "item4 cars",
      "item5"
    ];

    DescriptiveExpansionTile expansionTile =
        DescriptiveExpansionTile("testCategory", "testDescription", items);

    await tester.pumpWidget(testableWidget(child: expansionTile));

    final titleFinder = find.text("testCategory");

    await tester.tap(titleFinder);
    await tester.pump();

    final descriptionFinder = find.text("testDescription");
    final itemListFinder =
        find.text("item1 • item2 • item3 hello • item4 cars • item5");

    expect(titleFinder, findsOneWidget);
    expect(descriptionFinder, findsOneWidget);
    expect(itemListFinder, findsOneWidget);
  });

  testWidgets(
      'Expanded expansion tile with an empty description displays no description section at all',
      (WidgetTester tester) async {
    List<String> items = [
      "item1",
      "item2",
      "item3 hello",
      "item4 cars",
      "item5"
    ];

    DescriptiveExpansionTile expansionTile =
        DescriptiveExpansionTile("testCategory", "", items);

    await tester.pumpWidget(testableWidget(child: expansionTile));

    final titleFinder = find.text("testCategory");
    //Makes a gesture of a tap on the title
    await tester.tap(titleFinder); 
    await tester.pump();
    //Search for widget with key containing "description"
    final descriptionFinder = find.byKey(Key('description')); 
    final itemListFinder =
        find.text("item1 • item2 • item3 hello • item4 cars • item5");

    expect(titleFinder, findsOneWidget);
    expect(descriptionFinder, findsNothing);
    expect(itemListFinder, findsOneWidget);
  });

  testWidgets(
      'Expanded expansion tile with no items still contains space for the list',
      (WidgetTester tester) async {
    List<String> items = [];

    DescriptiveExpansionTile expansionTile =
        DescriptiveExpansionTile("testCategory", "testDescription", items);

    await tester.pumpWidget(testableWidget(child: expansionTile));

    final titleFinder = find.text("testCategory");

    await tester.tap(titleFinder);
    await tester.pump();

    final descriptionFinder = find.byKey(Key('description'));
    final itemListFinder = find.byKey(Key('listContainer'));

    expect(titleFinder, findsOneWidget);
    expect(descriptionFinder, findsOneWidget);
    expect(itemListFinder, findsOneWidget);
  });

  testWidgets(
      'Expanded expansion tile with a null list of items still contains space for the list',
      (WidgetTester tester) async {
    DescriptiveExpansionTile expansionTile =
        DescriptiveExpansionTile("testCategory", "testDescription", null);

    await tester.pumpWidget(testableWidget(child: expansionTile));

    final titleFinder = find.text("testCategory");

    await tester.tap(titleFinder);
    await tester.pump();

    final descriptionFinder = find.byKey(Key('description'));
    final itemListFinder = find.byKey(Key('listContainer'));

    expect(titleFinder, findsOneWidget);
    expect(descriptionFinder, findsOneWidget);
    expect(itemListFinder, findsOneWidget);
  });
}
