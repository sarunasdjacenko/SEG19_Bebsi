import 'package:flutter/material.dart';
import 'package:prep/utils/constants.dart';

import 'package:prep/utils/document_data_provider.dart';
import 'package:prep/widgets/recipe/recipe_card_content.dart';

///[RecipeCardBody] displays the title given by the [context]'s 
///[DocumentDataProvider] of the recipe and is 
///expandalbe when tapped on to show full recipe details via [RecipeCardContent].
class RecipeCardBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var title = DocumentDataProvider.of(context).documentData['title'] ??
        Constants.kDefaultRecipeTitle;
    var subtitle = DocumentDataProvider.of(context).documentData['subtitle'];
    assert(title is String);
    if (subtitle != null) {
      assert(subtitle is String);
    }

    List<Widget> recipeName = [
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          //overflow: TextOverflow.ellipsis,
          //maxLines: 1,
          style: Theme.of(context).textTheme.headline,
        ),
      ),
    ];
    if (subtitle != null) {
      recipeName.add(
        Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 18.0),
        ),
      );
    }

    return ExpansionTile(
      initiallyExpanded: Constants.kIsDebug,
      title: Column(
        verticalDirection: VerticalDirection.down,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: recipeName,
      ),
      children: <Widget>[
        RecipeCardContent(),
      ],
    );
  }
}
