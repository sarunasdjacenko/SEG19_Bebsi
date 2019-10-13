import 'package:flutter/material.dart';

import 'package:prep/utils/misc_functions.dart'
    show convertDynamicListToStringList;

import 'package:prep/widgets/recipe/recipe_ingredient_list_item.dart';
import 'package:prep/utils/constants.dart';

///[RecipeIngredientList] displays a list of [RecipeIngredientListItem]s in a [RecipeCard].
class RecipeIngredientList extends StatelessWidget {
  final dynamic dynamicIngredientList;

  RecipeIngredientList(this.dynamicIngredientList);

  @override
  Widget build(BuildContext context) {
    List<Widget> _ingredientListItems = [];

    for (String ingredient
        in convertDynamicListToStringList(dynamicIngredientList)) {
      _ingredientListItems.add(
        RecipeIngredientListItem(ingredient),
      );
    }

    return ExpansionTile(
      initiallyExpanded: Constants.kIsDebug,
      title: Text(
        Constants.kIngredientListHeadline,
        style: Theme.of(context).textTheme.button,
      ),
      children: _ingredientListItems,
      backgroundColor: Colors.black12,
    );
  }
}
