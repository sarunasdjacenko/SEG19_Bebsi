import 'package:flutter/material.dart';

import 'package:prep/utils/misc_functions.dart'
    show convertDynamicListToStringList;

import 'package:prep/widgets/recipe/recipe_method_list_item.dart';
import 'package:prep/utils/constants.dart';


///[RecipeMethodList] displays a list of [RecipeMethodListItem]s in a [RecipeCard].
///Each list item is automatically ennumerated.
class RecipeMethodList extends StatelessWidget {
  final dynamic dynamicMethodInstructions;

  RecipeMethodList(this.dynamicMethodInstructions);

  @override
  Widget build(BuildContext context) {
    List<String> methodInstructions =
        convertDynamicListToStringList(dynamicMethodInstructions);

    List<Widget> columnChildren = [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          Constants.kMethodListHeadline,
          style: Theme.of(context).textTheme.headline.copyWith(fontSize: 18.0),
        ),
      ),
    ];

    for (int i = 0; i < methodInstructions.length; i++) {
      columnChildren.add(
        RecipeMethodListItem(
          ordering: i + 1,
          instruction: methodInstructions[i],
        ),
      );

      //add dividers and ending padding
      if (i != methodInstructions.length - 1) {
        columnChildren.add(
          Divider(),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      verticalDirection: VerticalDirection.down,
      children: columnChildren,
    );
  }
}
