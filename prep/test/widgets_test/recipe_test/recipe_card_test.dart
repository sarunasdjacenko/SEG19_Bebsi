import 'package:flutter/material.dart';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep/utils/constants.dart';

import 'package:prep/widgets/recipe/recipe_card_widgets_export.dart';

class MockRecipeCardData extends Mock implements Map<String, dynamic> {
  static const String validTitle = 'valid title';
  static final Finder validTitleFinder = find.text(validTitle);

  static const String validSubtitle = 'valid subtitle';
  static final Finder validSubtitleFinder = find.text(validSubtitle);

  static const List<String> validLabels = <String>[
    'label',
    'label',
    'label',
  ];
  static final Finder labelFinder = find.text('label');

  static final Finder ingredientListFinder =
      find.text(Constants.kIngredientListHeadline);

  static const String kValidIngredient = 'ingredient';

  static const List<String> validIngredients = <String>[
    kValidIngredient,
    kValidIngredient,
    kValidIngredient,
  ];
  static final Finder ingredientListItemFinder = find.text(kValidIngredient);

  static final Finder methodListFinder =
      find.text(Constants.kMethodListHeadline);
  static const String kValidInstruction = 'instruction';
  static const List<String> validMethod = <String>[
    kValidInstruction,
    kValidInstruction,
    kValidInstruction,
  ];
  static final Finder methodListItemFinder = find.text(kValidInstruction);

  static const String validNote = 'note';
  static final Finder validNoteFinder =
      find.text('${Constants.kRecipeNotePrefix} $validNote');

  static final Finder urlButtonFinder =
      find.text(Constants.kViewRecipeOnlineButtonText);

  static const Map<String, dynamic> mockDocumentData = {
    'title': validTitle,
    'subtitle': validSubtitle,
    'labels': validLabels,
    'ingredients': validIngredients,
    'method': validMethod,
    'note': validNote,
    'externalURL': 'http://www.example.com',
    'recipeType': 'eggs',
    'backgroundImage': null,
  };

  MockRecipeCardData configure({
    String backgroundImage,
    @required String title,
    String subtitle,
    List<String> labels,
    List<String> ingredients,
    List<String> method,
    String note,
    String recipeType = 'default',
    String externalUrl,
  }) {
    when(this['backgroundImage']).thenReturn(backgroundImage);
    when(this['title']).thenReturn(title);
    when(this['subtitle']).thenReturn(subtitle);
    when(this['labels']).thenReturn(labels);
    when(this['ingredients']).thenReturn(ingredients);
    when(this['method']).thenReturn(method);
    when(this['note']).thenReturn(note);
    when(this['externalURL']).thenReturn(externalUrl);
    when(this['recipeType']).thenReturn(recipeType);

    return this;
  }

  MockRecipeCardData configureValid() => configure(
        title: validTitle,
        subtitle: validSubtitle,
        labels: validLabels,
        ingredients: validIngredients,
        method: validMethod,
        externalUrl: 'http://example.com',
        note: validNote,
      );

  MockRecipeCardData configureEmpty() => configure(
        title: null,
      );
}

void main() {
  Constants.kIsDebug = true;

  Widget makeTestableWidget(Widget child) => MaterialApp(
        home: SingleChildScrollView(
          child: child,
        ),
      );

  group('RecipeCard', () {
    testWidgets(
      'should build each component with all data fields set and valid',
      (WidgetTester tester) async {
        final RecipeCard cardToTest = RecipeCard(
          data: MockRecipeCardData().configureValid(),
        );

        await tester.pumpWidget(makeTestableWidget(cardToTest));
        await tester.pump();

        expect(MockRecipeCardData.validTitleFinder, findsOneWidget);
        expect(MockRecipeCardData.validSubtitleFinder, findsOneWidget);
        expect(MockRecipeCardData.labelFinder, findsNWidgets(3));
        expect(MockRecipeCardData.ingredientListFinder, findsOneWidget);
        expect(MockRecipeCardData.methodListFinder, findsOneWidget);
        expect(MockRecipeCardData.urlButtonFinder, findsOneWidget);
        expect(MockRecipeCardData.validNoteFinder, findsOneWidget);
        expect(MockRecipeCardData.methodListItemFinder, findsNWidgets(3));
        expect(MockRecipeCardData.ingredientListItemFinder, findsNWidgets(3));
      },
    );

    testWidgets(
      'should not build internal recipe if method list is not specified',
      (WidgetTester tester) async {
        final MockRecipeCardData mockRecipeCardData =
            MockRecipeCardData().configureValid();
        //remove method list
        when(mockRecipeCardData['method']).thenReturn(null);

        final RecipeCard cardToTest = RecipeCard(
          data: mockRecipeCardData,
        );

        await tester.pumpWidget(makeTestableWidget(cardToTest));
        await tester.pump();

        expect(MockRecipeCardData.ingredientListFinder, findsNothing);
        expect(MockRecipeCardData.methodListFinder, findsNothing);
        expect(MockRecipeCardData.methodListItemFinder, findsNothing);
        expect(MockRecipeCardData.ingredientListItemFinder, findsNothing);
      },
    );

    testWidgets(
      'should not build internal recipe if method ingredient list is not specified',
      (WidgetTester tester) async {
        final MockRecipeCardData mockRecipeCardData =
            MockRecipeCardData().configureValid();
        //remove method list
        when(mockRecipeCardData['ingredients']).thenReturn(null);

        final RecipeCard cardToTest = RecipeCard(
          data: mockRecipeCardData,
        );

        await tester.pumpWidget(makeTestableWidget(cardToTest));
        await tester.pump();

        expect(MockRecipeCardData.ingredientListFinder, findsNothing);
        expect(MockRecipeCardData.methodListFinder, findsNothing);
        expect(MockRecipeCardData.methodListItemFinder, findsNothing);
        expect(MockRecipeCardData.ingredientListItemFinder, findsNothing);
      },
    );

    testWidgets(
      'should build Error message if neither an internal nor external recipe are specified',
      (WidgetTester tester) async {
        final MockRecipeCardData mockRecipeCardData =
            MockRecipeCardData().configureValid();
        //remove method list
        when(mockRecipeCardData['ingredients']).thenReturn(null);
        when(mockRecipeCardData['method']).thenReturn(null);
        when(mockRecipeCardData['externalURL']).thenReturn(null);

        final RecipeCard cardToTest = RecipeCard(
          data: mockRecipeCardData,
        );

        await tester.pumpWidget(makeTestableWidget(cardToTest));
        await tester.pump();

        expect(MockRecipeCardData.ingredientListFinder, findsNothing);
        expect(MockRecipeCardData.methodListFinder, findsNothing);
        expect(MockRecipeCardData.methodListItemFinder, findsNothing);
        expect(MockRecipeCardData.ingredientListItemFinder, findsNothing);
        expect(MockRecipeCardData.urlButtonFinder, findsNothing);

        expect(find.text(Constants.kErrorRecipeNotFound), findsOneWidget);
      },
    );

    testWidgets('should build default data when required data is not spesified',
        (WidgetTester tester) async {
      final RecipeCard cardToTest = RecipeCard(
        data: MockRecipeCardData().configureEmpty(),
      );

      await tester.pumpWidget(makeTestableWidget(cardToTest));
      await tester.pump();

      expect(find.widgetWithText(RecipeCardBody, Constants.kDefaultRecipeTitle),
          findsOneWidget);
    });
  });
}
