import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/screens/appointment.screen.dart';

class MockBackend extends Mock implements BaseBackend {}

main() {
  final mockBackend = MockBackend();
  // Each inner list contains {Key for screen, Text on NavBar, Icon on NavBar}
  final expectedNavBarItemsList = [
    ['appointmentInfoScreen', 'Information', Icons.info],
    ['appointmentPrepScreen', 'Preparation', Icons.sort],
    ['dailyCheckupsScreen', 'Checkups', Icons.edit_attributes],
    ['messagingScreen', 'Dr. Chat', Icons.chat],
  ];

  List<Object> expectedNavBarKeysList() =>
      expectedNavBarItemsList.map((pairNameIcon) => pairNameIcon[0]).toList();

  List<Object> expectedNavBarNamesList() =>
      expectedNavBarItemsList.map((pairNameIcon) => pairNameIcon[1]).toList();

  List<Object> expectedNavBarIconsList() =>
      expectedNavBarItemsList.map((pairNameIcon) => pairNameIcon[2]).toList();

  Widget testableWidget({Widget child}) {
    return BackendProvider(
      backend: mockBackend,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  void setUpMockBackend() {
    when(mockBackend.contactNumber).thenReturn("");
    when(mockBackend.doctorName).thenReturn("");
    when(mockBackend.location).thenReturn("");
    when(mockBackend.appointmentName).thenReturn("");
    when(mockBackend.prepCardsSnapshots).thenReturn(null);
    when(mockBackend.dailyCheckupsSnapshots).thenReturn(null);
    when(mockBackend.categoryListSnapshots(any)).thenReturn(null);
    when(mockBackend.informationSnapshots(any)).thenReturn(null);
    when(mockBackend.messagesSnapshots(any)).thenAnswer(
      (_) => Stream.fromIterable([]),
    );
  }

  Future<void> setUpWidgetTester(WidgetTester tester) async {
    setUpMockBackend();

    await tester.pumpWidget(testableWidget(child: Appointment(0)));
    await tester.pump();
  }

  BottomNavigationBar getNavBar() {
    final appointmentPage = find.byKey(Key('appointmentPage'));
    final bottomNavigationNavBar =
        (appointmentPage.evaluate().first.widget as BottomNavigationBar);
    return bottomNavigationNavBar;
  }

  group('Appointment screen tests:', () {
    testWidgets(
      'there are 4 tab buttons: "Information", "Preparation", "Checkups", "Dr. Chat"',
      (WidgetTester tester) async {
        await setUpWidgetTester(tester);

        final navBarItemsNameList = getNavBar()
            .items
            .map((navBarItem) => (navBarItem.title as Text).data)
            .toList();

        expect(navBarItemsNameList, expectedNavBarNamesList());
      },
    );

    group('tapping icon button:', () {
      final navBarExpectedLength = expectedNavBarNamesList().length;

      for (int index = 0; index < navBarExpectedLength; ++index) {
        testWidgets(
          '"' + expectedNavBarNamesList()[index] + '" opens correct screen',
          (WidgetTester tester) async {
            await setUpWidgetTester(tester);
            await tester.pump();

            await tester.tap(find.byIcon(expectedNavBarIconsList()[index]));
            (index == 3) ? await tester.pumpAndSettle() : await tester.pump();

            expect(getNavBar().currentIndex, index);
            expect(find.byKey(Key(expectedNavBarKeysList()[index])),
                findsOneWidget);
          },
        );
      }
    });

    testWidgets(
      'tapping icon buttons navigates through the screens (3 full cycles)',
      (WidgetTester tester) async {
        await setUpWidgetTester(tester);
        await tester.pump();

        final navBarExpectedLength = expectedNavBarNamesList().length;

        for (int iteration = 0; iteration < 3; ++iteration) {
          for (int index = 0; index < navBarExpectedLength; ++index) {
            await tester.tap(find.byIcon(expectedNavBarIconsList()[index]));
            (index == 3) ? await tester.pumpAndSettle() : await tester.pump();

            expect(getNavBar().currentIndex, index);
            expect(find.byKey(Key(expectedNavBarKeysList()[index])),
                findsOneWidget);
          }
        }
      },
    );
  });
}
