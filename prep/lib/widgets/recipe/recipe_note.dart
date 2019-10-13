import 'package:flutter/material.dart';

import 'package:prep/utils/constants.dart';

///[RecipeNote] displays a high visibility note in a
///[RecipeCard] which is important for the reader to know.
class RecipeNote extends StatelessWidget {
  final dynamic note;

  RecipeNote(this.note);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Colors.red[400],
            Colors.red[700],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          "${Constants.kRecipeNotePrefix} $note",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}
