import 'package:flutter/material.dart';

import 'package:prep/screens/appointment.screen.dart';
import 'package:prep/utils/misc_functions.dart';

/// Displays one FAQ expansion tile in a default collapsed state. It contains a
/// question, displayed as the title of the expansion tile. When tapped, the
/// rest of the contents are showed. These include an answer text and up to 2
/// icon buttons.
class FaqExpansionTile extends StatelessWidget {
  final String question;
  final String answer;
  final bool chatShortcut;
  final bool infoShortcut;

  FaqExpansionTile(
      this.question, this.answer, this.chatShortcut, this.infoShortcut);

  /// Uses the class parameters to style each FAQ expansion tile widget. It
  /// contains 2 pieces of text (question and answer) along with two button
  /// icons: chatShortcut, navigating to the messaging screen and infoShortcut,
  /// navigating back to the preparation tab.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10.0, left: 10.0, bottom: 5.0),
      child: Card(
        elevation: 3.0,
        child: ExpansionTile(
          key: Key('expandableTile'),
          title: Text(stringValidator(question)),
          children: <Widget>[
            ListTile(
              title: Text(
                stringValidator(answer),
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                (chatShortcut)
                    ? IconButton(
                        key: Key('chatButton'),
                        icon: Icon(Icons.chat),
                        color: Colors.indigo[400],
                        onPressed: () {
                          Navigator.push(
                              context,
                              // Navigates to the messaging screen
                              MaterialPageRoute(
                                  builder: (context) => Appointment(3)));
                        })
                    : Container(),
                (infoShortcut)
                    ? IconButton(
                        key: Key('infoButton'),
                        icon: Icon(Icons.info),
                        color: Colors.deepPurple[400],
                        onPressed: () {
                          Navigator.push(
                              context,
                              // Navigates to the preparation tab
                              MaterialPageRoute(
                                  builder: (context) => Appointment(1)));
                        })
                    : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
