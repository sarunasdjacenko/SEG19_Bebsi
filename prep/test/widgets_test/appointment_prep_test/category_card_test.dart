import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/widgets/appointment_prep/category_card.dart';

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
      'A card containing the title Alowed Foods and a blue icon is displayed when the type is categoryList',
      (WidgetTester tester) async {
    CategoryCard categoryCard =
        CategoryCard("sample ID", "Allowed Foods", "categoryList");

    MockBackend mockBackend = new MockBackend();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: categoryCard));

    final textFinder = find.text('Allowed Foods');
    final iconFinder = find.byType(CircleAvatar);
    final iconColor =
        (iconFinder.evaluate().single.widget as CircleAvatar).backgroundColor;

    expect(textFinder, findsOneWidget);
    expect(iconFinder, findsOneWidget);
    expect(iconColor, Colors.blue[400]);
  });

  testWidgets(
      'A card containing the title FAQ and a green icon is displayed when the type is faqs',
      (WidgetTester tester) async {
    CategoryCard categoryCard = CategoryCard("sample ID", "FAQs", "faqs");

    MockBackend mockBackend = new MockBackend();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: categoryCard));

    final textFinder = find.text('FAQs');
    final iconFinder = find.byType(CircleAvatar);
    final iconColor =
        (iconFinder.evaluate().single.widget as CircleAvatar).backgroundColor;

    expect(textFinder, findsOneWidget);
    expect(iconFinder, findsOneWidget);
    expect(iconColor, Colors.green[400]);
  });

  testWidgets(
      'A card containing the title Good recipes and a red icon is displayed when the type is recipe',
      (WidgetTester tester) async {
    CategoryCard categoryCard =
        CategoryCard("sample ID", "Good recipes", "recipe");

    MockBackend mockBackend = new MockBackend();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: categoryCard));

    final textFinder = find.text('Good recipes');
    final iconFinder = find.byType(CircleAvatar);
    final iconColor =
        (iconFinder.evaluate().single.widget as CircleAvatar).backgroundColor;

    expect(textFinder, findsOneWidget);
    expect(iconFinder, findsOneWidget);
    expect(iconColor, Colors.red[400]);
  });

  testWidgets(
      'A card containing the title Interesting article and a deepPurple icon is displayed when the type is article',
      (WidgetTester tester) async {
    CategoryCard categoryCard =
        CategoryCard("sample ID", "Interesting article", "article");

    MockBackend mockBackend = new MockBackend();

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: categoryCard));

    final textFinder = find.text('Interesting article');
    final iconFinder = find.byType(CircleAvatar);
    final iconColor =
        (iconFinder.evaluate().single.widget as CircleAvatar).backgroundColor;

    expect(textFinder, findsOneWidget);
    expect(iconFinder, findsOneWidget);
    expect(iconColor, Colors.deepPurple[400]);
  });

  testWidgets(
      'Tapping on an article card navigates to the appropiate article screen',
      (WidgetTester tester) async {
    CategoryCard categoryCard =
        CategoryCard("sample ID", "Interesting article", "article");

    MockBackend mockBackend = new MockBackend();

    when(mockBackend.informationSnapshots("sample ID")).thenAnswer(null);

    await tester
        .pumpWidget(testableWidget(backend: mockBackend, child: categoryCard));

    final textFinder = find.text('Interesting article');

    await tester.tap(textFinder);
  });

  testWidgets(
      'Tapping on a recipe card navigates to the appropiate reipe screen',
          (WidgetTester tester) async {
        CategoryCard categoryCard =
        CategoryCard("sample ID", "Good recipe", "recipe");

        MockBackend mockBackend = new MockBackend();

        when(mockBackend.recipeSnapshots).thenAnswer(null);

        await tester
            .pumpWidget(testableWidget(backend: mockBackend, child: categoryCard));

        final textFinder = find.text('Good recipe');

        await tester.tap(textFinder);
      });

  testWidgets(
      'Tapping on an FAQ card navigates to the appropiate FAQ screen',
          (WidgetTester tester) async {
        CategoryCard categoryCard =
        CategoryCard("sample ID", "Frequently Asked Questions", "faqs");

        MockBackend mockBackend = new MockBackend();

        when(mockBackend.faqSnapshots).thenAnswer(null);

        await tester
            .pumpWidget(testableWidget(backend: mockBackend, child: categoryCard));

        final textFinder = find.text('Frequently Asked Questions');

        await tester.tap(textFinder);
      });

  testWidgets(
      'Tapping on a list card navigates to the appropiate list screen',
          (WidgetTester tester) async {
        CategoryCard categoryCard =
        CategoryCard("sample ID", "Important list", "categoryList");

        MockBackend mockBackend = new MockBackend();

        when(mockBackend.categoryListSnapshots("sample ID")).thenAnswer(null);

        await tester
            .pumpWidget(testableWidget(backend: mockBackend, child: categoryCard));

        final textFinder = find.text('Important list');

        await tester.tap(textFinder);
      });
}
