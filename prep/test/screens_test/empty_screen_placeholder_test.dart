import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:prep/screens/empty_screen_placeholder.dart';

void main() {
  Widget testableWidget({Widget child}) {
    return MaterialApp(home: child);
  }

  testWidgets('EmptyPlaceHolder should have a title and a subtitle', (WidgetTester tester) async {
    EmptyScreenPlaceholder emptyScreenPlaceholder = EmptyScreenPlaceholder('T', 'ST');

    await tester.pumpWidget(testableWidget(child: emptyScreenPlaceholder));

    final title = find.text('T');
    final subTitle = find.text('ST');

    expect(title, findsOneWidget);
    expect(subTitle, findsOneWidget);
  });

  testWidgets('EmptyPlaceHolder should have padding inbetween the title and subtitle widgets', (WidgetTester tester) async {
    EmptyScreenPlaceholder emptyScreenPlaceholder = EmptyScreenPlaceholder('T', 'ST');

    await tester.pumpWidget(testableWidget(child: emptyScreenPlaceholder));

    final padding = find.byKey(Key('padding'));

    expect(padding, findsOneWidget);
  });
}