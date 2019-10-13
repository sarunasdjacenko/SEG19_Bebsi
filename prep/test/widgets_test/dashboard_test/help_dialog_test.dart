import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prep/widgets/dashboard/help_dialog.dart';

void main() {
  Widget testableWidget({Widget child}) {
    return MaterialApp(home: child);
  }

  testWidgets('The help icon can be tapped and it produces an alert dialog with the provided text (Test)', (WidgetTester tester) async {
    MakeHelpIcon helpicon = MakeHelpIcon('Test');
    // Renders the UI with the icon
    await tester.pumpWidget(
      testableWidget(
        child: Scaffold(body: helpicon),
      ),
    );
    // Makes an event where the icon object is tapped
    await tester.tap(find.byWidget(helpicon));
    // Triggers a frame after a set amount of time
    await tester.pump();
    // Tests whether expected output is given on one widget
    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('The help icon can be tapped and it produces an alert dialog with the provided text (empty string)',
      (WidgetTester tester) async {
    MakeHelpIcon helpicon = MakeHelpIcon('');
    await tester.pumpWidget(
      testableWidget(
        child: Scaffold(body: helpicon),
      ),
    );
    await tester.tap(find.byWidget(helpicon));
    await tester.pump();
    //Expects to find a widget with no description
    expect(find.text(''), findsOneWidget);
  });

  testWidgets('The help icon can be tapped and it produces an alert dialog with the provided text a null String object',
      (WidgetTester tester) async {
    MakeHelpIcon helpicon = MakeHelpIcon(null);
    await tester.pumpWidget(
      testableWidget(
        child: Scaffold(body: helpicon),
      ),
    );
    await tester.tap(find.byWidget(helpicon));
    await tester.pump();
    //Expect an alert box saying "No Description Available"
    expect(find.widgetWithText(AlertDialog, 'N/A'),
        findsOneWidget);
  });
}
