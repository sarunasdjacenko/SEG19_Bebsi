import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'dart:io';

import 'package:prep/screens/dashboard.screen.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/utils/backend.dart';
import 'package:prep/utils/storage.dart';

class MockBackend extends Mock implements FirestoreBackend {}

class MockStorage extends Mock implements Storage {}

void main() {
  Widget testableWidget({Storage storage, MockBackend backend, Widget child}) {
    return BackendProvider(
      storage: storage,
      backend: backend,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets("A card should appear in the calendar if the data given to it contains one record", (WidgetTester tester) async {
    List<Map<String, Map<String, dynamic>>> maps = new List();

    maps.add({
      'sampleID1': {
        'contactNumber': '123456789',
        'datetime': Timestamp.fromDate(DateTime.now()),
        'doctor': 'Medicine Pillz',
        'expired': false,
        'location': "St. Thomas Hospital",
        'staffMember': 'sampleStaffMemberCode',
        'testID': 'sampleTestID',
        'testName': 'FDG PET Scan of the Heart',
        'used': false
      }
    });

    Future<List<Map<String, Map<String, dynamic>>>> futureMap =
        new Future(() => maps);

    MockBackend mockBackend = new MockBackend();
    when(mockBackend.appointmentCodes()).thenAnswer((_) => futureMap);

    File testFile = new File("samplePath");

    MockStorage mockStorage = new MockStorage();
    when(mockStorage.fileExists()).thenAnswer((_) => Future(() => true));
    when(mockStorage.writeData(any)).thenAnswer((_) => Future(() => testFile));
    when(mockStorage.readData()).thenAnswer((_) => Future(() => "sampleID1"));

    Dashboard dashboard = new Dashboard();

    await tester.pumpWidget(testableWidget(
        storage: mockStorage, backend: mockBackend, child: dashboard));
    await tester.pump(Duration.zero);

    final cardFinder = find.byType(Card);
    expect(cardFinder, findsOneWidget);
  });

  testWidgets(
      "The empty screen place holder is displayed if the calendar is empty",
      (WidgetTester tester) async {
    List<Map<String, Map<String, dynamic>>> maps = new List();

    Future<List<Map<String, Map<String, dynamic>>>> futureMap =
        new Future(() => maps);

    MockBackend mockBackend = new MockBackend();
    when(mockBackend.appointmentCodes()).thenAnswer((_) => futureMap);

    File testFile = new File("samplePath");

    MockStorage mockStorage = new MockStorage();
    when(mockStorage.fileExists()).thenAnswer((_) => Future(() => true));
    when(mockStorage.writeData(any)).thenAnswer((_) => Future(() => testFile));
    when(mockStorage.readData()).thenAnswer((_) => Future(() => "sampleID1"));

    Dashboard dashboard = new Dashboard();

    await tester.pumpWidget(testableWidget(
        storage: mockStorage, backend: mockBackend, child: dashboard));
    await tester.pump(Duration.zero);

    final cardFinder = find.byType(Card);
    final emptyPlaceHolderFinder = find.byType(EmptyScreenPlaceholder);

    expect(cardFinder, findsNothing);
    expect(emptyPlaceHolderFinder, findsOneWidget);
  });

  testWidgets("The empty screen place holder is displayed if the data is null",
      (WidgetTester tester) async {
    List<Map<String, Map<String, dynamic>>> maps = new List();

    Future<List<Map<String, Map<String, dynamic>>>> futureMap =
        new Future(() => maps);

    MockBackend mockBackend = new MockBackend();
    when(mockBackend.appointmentCodes()).thenAnswer((_) => null);

    File testFile = new File("samplePath");

    MockStorage mockStorage = new MockStorage();
    when(mockStorage.fileExists()).thenAnswer((_) => Future(() => true));
    when(mockStorage.writeData(any)).thenAnswer((_) => Future(() => testFile));
    when(mockStorage.readData()).thenAnswer((_) => Future(() => "sampleID1"));

    Dashboard dashboard = new Dashboard();

    await tester.pumpWidget(testableWidget(
        storage: mockStorage, backend: mockBackend, child: dashboard));
    await tester.pump(Duration.zero);

    final cardFinder = find.byType(Card);
    final emptyPlaceHolderFinder = find.byType(EmptyScreenPlaceholder);

    expect(cardFinder, findsNothing);
    expect(emptyPlaceHolderFinder, findsOneWidget);
  });

  testWidgets(
      "Floating action button can be pressed and the alert dialog and its components are displayed correctly",
      (WidgetTester tester) async {
    List<Map<String, Map<String, dynamic>>> maps = new List();

    maps.add({
      'sampleID1': {
        'contactNumber': '123456789',
        'datetime': Timestamp.fromDate(DateTime.now()),
        'doctor': 'Medicine Pillz',
        'expired': false,
        'location': "St. Thomas Hospital",
        'staffMember': 'sampleStaffMemberCode',
        'testID': 'sampleTestID',
        'testName': 'FDG PET Scan of the Heart',
        'used': false
      }
    });

    Future<List<Map<String, Map<String, dynamic>>>> futureMap =
        new Future(() => maps);

    MockBackend mockBackend = new MockBackend();
    when(mockBackend.appointmentCodes()).thenAnswer((_) => futureMap);

    File testFile = new File("samplePath");

    MockStorage mockStorage = new MockStorage();
    when(mockStorage.fileExists()).thenAnswer((_) => Future(() => true));
    when(mockStorage.writeData(any)).thenAnswer((_) => Future(() => testFile));
    when(mockStorage.readData()).thenAnswer((_) => Future(() => "sampleID1"));

    Dashboard dashboard = new Dashboard();

    await tester.pumpWidget(testableWidget(
        storage: mockStorage, backend: mockBackend, child: dashboard));
    await tester.pump(Duration.zero);

    final floatingActionButtonFinder = find.byType(FloatingActionButton);
    expect(floatingActionButtonFinder, findsOneWidget);

    await tester.tap(floatingActionButtonFinder);
    await tester.pump();

    final alertDialogFinder = find.byType(AlertDialog);
    final textFormFieldFinder = find.byType(TextFormField);
    final submitButtonFinder = find.byType(RaisedButton);

    expect(alertDialogFinder, findsOneWidget);
    expect(textFormFieldFinder, findsOneWidget);
    expect(submitButtonFinder, findsOneWidget);
  });

  testWidgets(
      "The widget opends to an empty calendar. The new code dialog is oppened and a new available code is added. The new code is closed and the calendar populated",
      (WidgetTester tester) async {
    List<Map<String, Map<String, dynamic>>> maps = new List();

    maps.add({
      'sampleID1': {
        'contactNumber': '123456789',
        'datetime': Timestamp.fromDate(DateTime.now()),
        'doctor': 'Medicine Pillz',
        'expired': false,
        'location': "St. Thomas Hospital",
        'staffMember': 'sampleStaffMemberCode',
        'testID': 'sampleTestID',
        'testName': 'FDG PET Scan of the Heart',
        'used': false
      }
    });

    Future<List<Map<String, Map<String, dynamic>>>> futureMap =
        new Future(() => maps);

    MockBackend mockBackend = new MockBackend();
    when(mockBackend.appointmentCodes()).thenAnswer((_) => futureMap);
    when(mockBackend.setAppointmentCodeUsed(any)).thenAnswer((_) {});
    File testFile = new File("samplePath");

    int writeInstructionCounter = 0;
    String postAdditionResponse = "";

    MockStorage mockStorage = new MockStorage();
    when(mockStorage.fileExists()).thenAnswer((_) => Future(() => true));
    when(mockStorage.writeData(any)).thenAnswer((_) {
      writeInstructionCounter++;

      if (writeInstructionCounter > 1) {
        postAdditionResponse = "sampleID1";
      }

      Future(() => testFile);
    });
    when(mockStorage.readData())
        .thenAnswer((_) => Future(() => postAdditionResponse));

    Dashboard dashboard = new Dashboard();

    await tester.pumpWidget(testableWidget(
        storage: mockStorage, backend: mockBackend, child: dashboard));
    await tester.pump(Duration.zero);

    final emptyPlaceHolderFinder = find.byType(EmptyScreenPlaceholder);
    final floatingActionButtonFinder = find.byType(FloatingActionButton);

    expect(floatingActionButtonFinder, findsOneWidget);
    expect(emptyPlaceHolderFinder, findsOneWidget);

    await tester.tap(floatingActionButtonFinder);
    await tester.pump(Duration.zero);

    final alertDialogFinder = find.byType(AlertDialog);
    final textFormFieldFinder = find.byType(TextFormField);
    final submitButtonFinder = find.byType(RaisedButton);

    expect(alertDialogFinder, findsOneWidget);
    expect(textFormFieldFinder, findsOneWidget);
    expect(submitButtonFinder, findsOneWidget);

    await tester.tap(textFormFieldFinder);
    await tester.pump(Duration.zero);

    await tester.enterText(textFormFieldFinder, "sampleID1");
    await tester.pump(Duration.zero);

    await tester.tap(submitButtonFinder);
    await tester.pumpAndSettle();

    final calendarCardFinder = find.byType(Card);
    expect(calendarCardFinder, findsOneWidget);
    expect(emptyPlaceHolderFinder, findsNothing);
  });

  testWidgets(
      "Please enter a code is displayed when the SUBMIT button is pressed without typing a code in",
      (WidgetTester tester) async {
    List<Map<String, Map<String, dynamic>>> maps = new List();

    maps.add({
      'sampleID1': {
        'contactNumber': '123456789',
        'datetime': Timestamp.fromDate(DateTime.now()),
        'doctor': 'Medicine Pillz',
        'expired': false,
        'location': "St. Thomas Hospital",
        'staffMember': 'sampleStaffMemberCode',
        'testID': 'sampleTestID',
        'testName': 'FDG PET Scan of the Heart',
        'used': false
      }
    });

    Future<List<Map<String, Map<String, dynamic>>>> futureMap =
        new Future(() => maps);

    MockBackend mockBackend = new MockBackend();
    when(mockBackend.appointmentCodes()).thenAnswer((_) => futureMap);
    when(mockBackend.setAppointmentCodeUsed(any)).thenAnswer((_) {});
    File testFile = new File("samplePath");

    int writeInstructionCounter = 0;
    String postAdditionResponse = "";

    MockStorage mockStorage = new MockStorage();
    when(mockStorage.fileExists()).thenAnswer((_) => Future(() => true));
    when(mockStorage.writeData(any)).thenAnswer((_) {
      writeInstructionCounter++;

      if (writeInstructionCounter > 1) {
        postAdditionResponse = "sampleID1";
      }

      Future(() => testFile);
    });
    when(mockStorage.readData())
        .thenAnswer((_) => Future(() => postAdditionResponse));

    Dashboard dashboard = new Dashboard();

    await tester.pumpWidget(testableWidget(
        storage: mockStorage, backend: mockBackend, child: dashboard));
    await tester.pump(Duration.zero);

    final emptyPlaceHolderFinder = find.byType(EmptyScreenPlaceholder);
    final floatingActionButtonFinder = find.byType(FloatingActionButton);

    expect(floatingActionButtonFinder, findsOneWidget);
    expect(emptyPlaceHolderFinder, findsOneWidget);

    await tester.tap(floatingActionButtonFinder);
    await tester.pump(Duration.zero);

    final alertDialogFinder = find.byType(AlertDialog);
    final textFormFieldFinder = find.byType(TextFormField);
    final submitButtonFinder = find.byType(RaisedButton);

    expect(alertDialogFinder, findsOneWidget);
    expect(textFormFieldFinder, findsOneWidget);
    expect(submitButtonFinder, findsOneWidget);

    await tester.tap(submitButtonFinder);
    await tester.pumpAndSettle();

    final validatorTextFinder = find.text("Please enter a code");

    expect(validatorTextFinder, findsOneWidget);
    expect(emptyPlaceHolderFinder, findsOneWidget);
  });

  testWidgets(
      "Invalid code message displayed when a code that is not in the database is entered",
      (WidgetTester tester) async {
    List<Map<String, Map<String, dynamic>>> maps = new List();

    Future<List<Map<String, Map<String, dynamic>>>> futureMap =
        new Future(() => maps);

    MockBackend mockBackend = new MockBackend();
    when(mockBackend.appointmentCodes()).thenAnswer((_) => futureMap);
    when(mockBackend.setAppointmentCodeUsed(any)).thenAnswer((_) {});
    File testFile = new File("samplePath");

    int writeInstructionCounter = 0;
    String postAdditionResponse = "";

    MockStorage mockStorage = new MockStorage();
    when(mockStorage.fileExists()).thenAnswer((_) => Future(() => true));
    when(mockStorage.writeData(any)).thenAnswer((_) {
      writeInstructionCounter++;

      if (writeInstructionCounter > 1) {
        postAdditionResponse = "sampleID1";
      }

      Future(() => testFile);
    });
    when(mockStorage.readData())
        .thenAnswer((_) => Future(() => postAdditionResponse));

    Dashboard dashboard = new Dashboard();

    await tester.pumpWidget(testableWidget(
        storage: mockStorage, backend: mockBackend, child: dashboard));
    await tester.pump(Duration.zero);

    final emptyPlaceHolderFinder = find.byType(EmptyScreenPlaceholder);
    final floatingActionButtonFinder = find.byType(FloatingActionButton);

    expect(floatingActionButtonFinder, findsOneWidget);
    expect(emptyPlaceHolderFinder, findsOneWidget);

    await tester.tap(floatingActionButtonFinder);
    await tester.pump(Duration.zero);

    final alertDialogFinder = find.byType(AlertDialog);
    final textFormFieldFinder = find.byType(TextFormField);
    final submitButtonFinder = find.byType(RaisedButton);

    expect(alertDialogFinder, findsOneWidget);
    expect(textFormFieldFinder, findsOneWidget);
    expect(submitButtonFinder, findsOneWidget);

    await tester.tap(textFormFieldFinder);
    await tester.pump(Duration.zero);

    await tester.enterText(textFormFieldFinder, "nope");
    await tester.pump(Duration.zero);

    await tester.tap(submitButtonFinder);
    await tester.pumpAndSettle();

    final calendarCardFinder = find.text("Invalid code");
    expect(calendarCardFinder, findsOneWidget);
    expect(emptyPlaceHolderFinder, findsOneWidget);
  });

  testWidgets(
      "This appointment is in your calendar message displayed when an already added code is submitted",
      (WidgetTester tester) async {
    List<Map<String, Map<String, dynamic>>> maps = new List();

    maps.add({
      'sampleID1': {
        'contactNumber': '123456789',
        'datetime': Timestamp.fromDate(DateTime.now()),
        'doctor': 'Medicine Pillz',
        'expired': false,
        'location': "St. Thomas Hospital",
        'staffMember': 'sampleStaffMemberCode',
        'testID': 'sampleTestID',
        'testName': 'FDG PET Scan of the Heart',
        'used': false
      }
    });

    maps.add({
      'sampleID2': {
        'contactNumber': '123456789',
        'datetime': Timestamp.fromDate(DateTime.now()),
        'doctor': 'Medicine Pillz',
        'expired': false,
        'location': "St. Thomas Hospital",
        'staffMember': 'sampleStaffMemberCode',
        'testID': 'sampleTestID',
        'testName': 'FDG PET Scan of the Heart',
        'used': false
      }
    });

    Future<List<Map<String, Map<String, dynamic>>>> futureMap =
        new Future(() => maps);

    MockBackend mockBackend = new MockBackend();
    when(mockBackend.appointmentCodes()).thenAnswer((_) => futureMap);
    when(mockBackend.setAppointmentCodeUsed(any)).thenAnswer((_) {});
    File testFile = new File("samplePath");

    int writeInstructionCounter = 0;
    String postAdditionResponse = "sampleID2";

    MockStorage mockStorage = new MockStorage();
    when(mockStorage.fileExists()).thenAnswer((_) => Future(() => true));
    when(mockStorage.writeData(any)).thenAnswer((_) {
      writeInstructionCounter++;

      if (writeInstructionCounter > 1) {
        postAdditionResponse = postAdditionResponse + ",sampleID1";
      }

      Future(() => testFile);
    });
    when(mockStorage.readData())
        .thenAnswer((_) => Future(() => postAdditionResponse));

    Dashboard dashboard = new Dashboard();

    await tester.pumpWidget(testableWidget(
        storage: mockStorage, backend: mockBackend, child: dashboard));
    await tester.pump(Duration.zero);

    final emptyPlaceHolderFinder = find.byType(EmptyScreenPlaceholder);
    final floatingActionButtonFinder = find.byType(FloatingActionButton);

    expect(floatingActionButtonFinder, findsOneWidget);
    expect(emptyPlaceHolderFinder, findsNothing);

    await tester.tap(floatingActionButtonFinder);
    await tester.pump(Duration.zero);

    final alertDialogFinder = find.byType(AlertDialog);
    final textFormFieldFinder = find.byType(TextFormField);
    final submitButtonFinder = find.byType(RaisedButton);

    expect(alertDialogFinder, findsOneWidget);
    expect(textFormFieldFinder, findsOneWidget);
    expect(submitButtonFinder, findsOneWidget);

    await tester.enterText(textFormFieldFinder, "sampleID2");
    await tester.pump(Duration.zero);

    await tester.tap(submitButtonFinder);
    await tester.pumpAndSettle();

    final validatorTextFinder =
        find.text("This appointment is in your calendar");
    expect(validatorTextFinder, findsOneWidget);
    expect(emptyPlaceHolderFinder, findsNothing);
  });

  testWidgets("Used codes cannot be added to the calendar",
      (WidgetTester tester) async {
    List<Map<String, Map<String, dynamic>>> maps = new List();

    maps.add({
      'sampleID1': {
        'contactNumber': '123456789',
        'datetime': Timestamp.fromDate(DateTime.now()),
        'doctor': 'Medicine Pillz',
        'expired': false,
        'location': "St. Thomas Hospital",
        'staffMember': 'sampleStaffMemberCode',
        'testID': 'sampleTestID',
        'testName': 'FDG PET Scan of the Heart',
        'used': true
      }
    });

    Future<List<Map<String, Map<String, dynamic>>>> futureMap =
        new Future(() => maps);

    MockBackend mockBackend = new MockBackend();
    when(mockBackend.appointmentCodes()).thenAnswer((_) => futureMap);
    when(mockBackend.setAppointmentCodeUsed(any)).thenAnswer((_) {});
    File testFile = new File("samplePath");

    int writeInstructionCounter = 0;
    String postAdditionResponse = "";

    MockStorage mockStorage = new MockStorage();
    when(mockStorage.fileExists()).thenAnswer((_) => Future(() => true));
    when(mockStorage.writeData(any)).thenAnswer((_) {
      writeInstructionCounter++;

      if (writeInstructionCounter > 1) {
        postAdditionResponse = "sampleID1";
      }

      Future(() => testFile);
    });
    when(mockStorage.readData())
        .thenAnswer((_) => Future(() => postAdditionResponse));

    Dashboard dashboard = new Dashboard();

    await tester.pumpWidget(testableWidget(
        storage: mockStorage, backend: mockBackend, child: dashboard));
    await tester.pump(Duration.zero);

    final emptyPlaceHolderFinder = find.byType(EmptyScreenPlaceholder);
    final floatingActionButtonFinder = find.byType(FloatingActionButton);

    expect(floatingActionButtonFinder, findsOneWidget);
    expect(emptyPlaceHolderFinder, findsOneWidget);

    await tester.tap(floatingActionButtonFinder);
    await tester.pump(Duration.zero);

    final alertDialogFinder = find.byType(AlertDialog);
    final textFormFieldFinder = find.byType(TextFormField);
    final submitButtonFinder = find.byType(RaisedButton);

    expect(alertDialogFinder, findsOneWidget);
    expect(textFormFieldFinder, findsOneWidget);
    expect(submitButtonFinder, findsOneWidget);

    await tester.tap(textFormFieldFinder);
    await tester.pump(Duration.zero);

    await tester.enterText(textFormFieldFinder, "sampleID1");
    await tester.pump(Duration.zero);

    await tester.tap(submitButtonFinder);
    await tester.pumpAndSettle();

    final validatorMessageFinder = find.text('Invalid code');
    expect(validatorMessageFinder, findsOneWidget);
    expect(emptyPlaceHolderFinder, findsOneWidget);
  });

  testWidgets("Refresh button is clickable", (WidgetTester tester)async{
    List<Map<String, Map<String, dynamic>>> maps = new List();

    maps.add({
      'sampleID1': {
        'contactNumber': '123456789',
        'datetime': Timestamp.fromDate(DateTime.now()),
        'doctor': 'Medicine Pillz',
        'expired': false,
        'location': "St. Thomas Hospital",
        'staffMember': 'sampleStaffMemberCode',
        'testID': 'sampleTestID',
        'testName': 'FDG PET Scan of the Heart',
        'used': false
      }
    });

    Future<List<Map<String, Map<String, dynamic>>>> futureMap =
    new Future(() => maps);

    MockBackend mockBackend = new MockBackend();
    when(mockBackend.appointmentCodes()).thenAnswer((_) => futureMap);

    File testFile = new File("samplePath");

    String returnStorageData = "sampleID1";

    MockStorage mockStorage = new MockStorage();
    when(mockStorage.fileExists()).thenAnswer((_) => Future(() => true));
    when(mockStorage.writeData(any)).thenAnswer((_) => Future(() => testFile));
    when(mockStorage.readData()).thenAnswer((_) => Future(() => returnStorageData));

    Dashboard dashboard = new Dashboard();

    await tester.pumpWidget(testableWidget(
        storage: mockStorage, backend: mockBackend, child: dashboard));
    await tester.pump(Duration.zero);

    final cardFinder = find.byType(Card);
    expect(cardFinder, findsOneWidget);

    maps.add({
      'sampleID2': {
        'contactNumber': '123456789',
        'datetime': Timestamp.fromDate(DateTime.now()),
        'doctor': 'Medicine Pillz',
        'expired': false,
        'location': "St. Thomas Hospital",
        'staffMember': 'sampleStaffMemberCode',
        'testID': 'sampleTestID',
        'testName': 'FDG PET Scan of the Heart',
        'used': false
      }
    });

    returnStorageData = returnStorageData + ",sampleID2";

    final singleCardFinder = find.byType(Card);
    expect(singleCardFinder, findsOneWidget);

    await tester.tap(find.byKey(Key('refreshButton')));
    await tester.pumpAndSettle();

    final multipleCardFinder = find.byType(Card);
    expect(multipleCardFinder, findsNWidgets(2));
  });

  testWidgets("Help button is clickable and displays the help dialog", (WidgetTester tester)async{
    List<Map<String, Map<String, dynamic>>> maps = new List();

    Future<List<Map<String, Map<String, dynamic>>>> futureMap =
    new Future(() => maps);

    MockBackend mockBackend = new MockBackend();
    when(mockBackend.appointmentCodes()).thenAnswer((_) => futureMap);

    File testFile = new File("samplePath");

    String returnStorageData = "sampleID1";

    MockStorage mockStorage = new MockStorage();
    when(mockStorage.fileExists()).thenAnswer((_) => Future(() => true));
    when(mockStorage.writeData(any)).thenAnswer((_) => Future(() => testFile));
    when(mockStorage.readData()).thenAnswer((_) => Future(() => returnStorageData));

    Dashboard dashboard = new Dashboard();

    await tester.pumpWidget(testableWidget(
        storage: mockStorage, backend: mockBackend, child: dashboard));
    await tester.pump(Duration.zero);

    final helpButtonFinder = find.byKey(Key("helpButton"));
    expect(helpButtonFinder, findsOneWidget);

    await tester.tap(helpButtonFinder);
    await tester.pump();

    final helpAlertDialogFinder = find.byType(AlertDialog);
    expect(helpAlertDialogFinder, findsOneWidget);
  });
}
