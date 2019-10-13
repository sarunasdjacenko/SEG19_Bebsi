import 'package:flutter/material.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/utils/message_crypto.dart';

/// Creates the text composer stateful widget, used to input and send a message.
class TextComposer extends StatefulWidget {
  @override
  State createState() => _TextComposerState();
}

/// Creates the state for the text composer.
class _TextComposerState extends State<TextComposer> {
  TextEditingController _textController = TextEditingController();
  bool _hasTyped = false;

  void _sendMessage(String messageText) {
    final BaseBackend backend = BackendProvider.of(context).backend;
    if (_hasTyped) {
      setState(() => _hasTyped = false);
      String encryptedMessage =
          MessageCrypto.encryptMessage(backend.appointmentID, messageText);
      backend.sendMessage(encryptedMessage);
      _textController.clear();
    }
  }

  /// Builds the text composer.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).accentColor),
        child: Container(
          padding: EdgeInsets.only(left: 8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: SingleChildScrollView(
                      child: TextField(
                        key: Key('textField'),
                        autocorrect: true,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: _textController,
                        onChanged: (userInputText) {
                          setState(() => _hasTyped = userInputText.length > 0);
                        },
                        decoration: InputDecoration.collapsed(
                            hintText: "Type a message"),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        key: Key('sendButton'),
                        icon: Icon(
                          Icons.send,
                          color: (_hasTyped)
                              ? Theme.of(context).accentColor
                              : Theme.of(context).buttonColor,
                        ),
                        onPressed: () =>
                            _sendMessage(_textController.text.trim()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
