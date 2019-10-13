import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:prep/utils/backend_provider.dart';
import 'package:prep/utils/message_crypto.dart';
import 'package:prep/widgets/messaging/messages_view.dart';
import 'package:prep/widgets/messaging/text_composer.dart';

/// Creates messaging screen stateful widget, which contains an input and all messages.
class MessagingScreen extends StatefulWidget {
  @override
  State createState() => _MessagingScreenState();
}

/// Creates the state for the messaging screen.
class _MessagingScreenState extends State<MessagingScreen> {
  MessagesView _messagesView = MessagesView();
  TextComposer _textComposer = TextComposer();
  StreamSubscription<List<Map<String, dynamic>>> _messageStreamSubscription;

  /// Adds a new message.
  void _addNewMessage(Map<String, dynamic> message) {
    String decryptedMessage = MessageCrypto.decryptMessage(
        BackendProvider.of(context).backend.appointmentID, message['content']);

    if (decryptedMessage != '')
      _messagesView.addMessage(
        messageText: decryptedMessage,
        datetime: message['datetime'].toDate(),
        isPatient: message['isPatient'],
      );
  }

  /// Creates a subscription that listens for new messages, while on the messaging screen.
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _messageStreamSubscription = BackendProvider.of(context)
          .backend
          .messagesSnapshots(true)
          .listen((list) => list.forEach((message) => _addNewMessage(message)));
    });
  }

  /// Cancels the subscribtion that listened for new messages.
  @override
  void dispose() {
    _messageStreamSubscription.cancel();

    super.dispose();
  }

  /// Builds the messaging screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('messagingScreen'),
      resizeToAvoidBottomInset: false,
      body: Column(children: <Widget>[
        _messagesView,
        Divider(height: 1.0),
        _textComposer,
      ]),
    );
  }
}
