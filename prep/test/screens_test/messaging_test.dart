import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/utils/message_crypto.dart';
import 'package:prep/screens/messaging.screen.dart';

/// _messagesCollectionFirestore: mock list of messages in appointment in firestore
/// _messagesSentCollectionFirestore: mock list of sent messages in appointment in firestore,
/// _messagesSentCollectionFirestore is not real, as DocumentChanges automatically keeps track
class MockBackend extends Mock implements BaseBackend {
  List<Map<String, dynamic>> _messagesCollectionFirestore = [];
  List<Map<String, dynamic>> _messagesSentCollectionFirestore = [];

  List<Map<String, dynamic>> get mockMessagesCollection =>
      _messagesCollectionFirestore;
  List<Map<String, dynamic>> get mockMessagesSentCollection =>
      _messagesSentCollectionFirestore;
}

main() {
  final mockBackend = MockBackend();

  Widget testableWidget({Widget child}) {
    return BackendProvider(
      backend: mockBackend,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  void setUpMockBackend() {
    when(mockBackend.appointmentID).thenReturn('abcdefghi');

    when(mockBackend.messagesSnapshots(any)).thenAnswer(
      (_) => Stream.periodic(Duration(milliseconds: 100), (_) {
            List<Map<String, dynamic>> mockMessagesCollectionToSend =
                mockBackend.mockMessagesCollection
                    .map((message) => (mockBackend.mockMessagesSentCollection
                            .contains(message))
                        ? null
                        : message)
                    .where((message) => message != null)
                    .toList();
            mockBackend.mockMessagesSentCollection
                .addAll(mockMessagesCollectionToSend);
            return mockMessagesCollectionToSend;
          }),
    );

    when(mockBackend.sendMessage(any)).thenAnswer((invocation) {
      mockBackend.mockMessagesCollection.add({
        'content': invocation.positionalArguments.first,
        'datetime': Timestamp.fromDate(DateTime.now()),
        'isPatient': true,
        'seenByPatient': true,
      });
    });
  }

  Future<void> setUpWidgetTester(WidgetTester tester) async {
    setUpMockBackend();

    await tester.pumpWidget(testableWidget(child: MessagingScreen()));
    await tester.pumpAndSettle();
  }

  group('Messaging screen tests:', () {
    final testMessages = [
      "First Test Message!",
      "Second Test Message!",
      "Third Test Message!",
      "Fourth Test Message!",
      "Fifth Test Message!",
    ];

    testWidgets(
      'text field, send button, and messages view are found',
      (WidgetTester tester) async {
        await setUpWidgetTester(tester);

        final textField = find.byKey(Key('textField'));
        final sendButton = find.byKey(Key('sendButton'));
        final messagesView = find.byKey(Key('messagesView'));

        expect(textField, findsOneWidget);
        expect(sendButton, findsOneWidget);
        expect(messagesView, findsOneWidget);
      },
    );

    testWidgets(
      "messages can be encrypted and sent; encrypted messages can be received",
      (WidgetTester tester) async {
        await setUpWidgetTester(tester);

        final textField = find.byKey(Key('textField'));
        final sendButton = find.byKey(Key('sendButton'));
        final messagesView = find.byKey(Key('messagesView'));

        for (String message in testMessages) {
          await tester.enterText(textField, message);
          await tester.tap(sendButton);
          await tester.pumpAndSettle();

          ListView messageListView = (messagesView.evaluate().single.widget);

          expect(messageListView.semanticChildCount,
              mockBackend.mockMessagesCollection.length);
        }
      },
    );

    test(
      "received encrypted messages can be decrypted",
      () {
        final decryptedMessages =
            mockBackend.mockMessagesCollection.map((message) {
          return MessageCrypto.decryptMessage(
            mockBackend.appointmentID,
            message['content'],
          );
        }).toList();

        expect(decryptedMessages, testMessages);
      },
    );
  });
}
