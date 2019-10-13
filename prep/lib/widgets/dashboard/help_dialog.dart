import 'package:flutter/material.dart';

import 'package:prep/utils/misc_functions.dart';

/// Displays a help icon that triggers an alert dialog to appear when tapped.
/// The alert dialog can contain a message.
class MakeHelpIcon extends StatelessWidget {
  // Information that is stored in an alert box
  final String info;

  MakeHelpIcon(this.info);

  /// Builds an icon button with an event that triggers the display of the
  /// alert dialog.
  Widget build(BuildContext context) {
    return IconButton(
        key: Key("helpButton"),
        icon: new Icon(Icons.help, color: Colors.white),
        onPressed: () {
          _displayAlertDialog(context, info);
        });
  }

  /// Displays an alert dialog formatted as a card containing the heading 'Help'
  /// and a subheading containing whatever information was passed to the
  /// constructor of the widget.
  void _displayAlertDialog(BuildContext context, String text) {
    //Makes an alert box storing basic information
    var alertDialog = AlertDialog(
      title: Text("Help",
          textAlign: TextAlign.center, style: TextStyle(fontSize: 30.0)),
      content: Text(stringValidator(text),
          textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0)),
    );
    //Used to output the dialog box on screen
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
