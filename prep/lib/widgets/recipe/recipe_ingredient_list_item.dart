import 'package:flutter/material.dart';

///[RecipeIngredientListItem] displays a single ingredient 
///for a recipe in a [RecipeCard].
class RecipeIngredientListItem extends StatelessWidget {
  final String ingredient;

  RecipeIngredientListItem(this.ingredient);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 32.0),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.check),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            ingredient,
            style: TextStyle(
              fontSize: 14.0,
              color: Theme.of(context).textTheme.body2.color,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
