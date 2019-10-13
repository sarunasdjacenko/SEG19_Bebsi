import 'package:flutter/material.dart';

import 'package:validators/validators.dart';

import 'package:prep/utils/document_data_provider.dart';
import 'package:prep/widgets/recipe/error_recipe_not_found.dart';
import 'package:prep/widgets/recipe/recipe_ingredient_list.dart';
import 'package:prep/widgets/recipe/recipe_method_list.dart';
import 'package:prep/widgets/recipe/recipe_note.dart';
import 'package:prep/widgets/recipe/external_recipe_link.dart';


///[RecipeCardContent] does data validation on data given by the [context]'s 
///[DocumentDataProvider] and builds the content of the [RecipeCard] from that data.
///If some of the data is missing it will not build that particular [RecipeCard] subwidget.
class RecipeCardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> content = [];
    //get data
    final documentData = DocumentDataProvider.of(context).documentData;

    final dynamic dynamicIngredientListData = documentData['ingredients'];

    final dynamic dynamicMethodListData = documentData['method'];
    final dynamic dynamicExternalUrlData =
        documentData['externalURL']?.toString();
    final dynamic dynamicNoteData = documentData['note']?.toString();

    //check data

    //internal recipe must either exist fully or doesn't at all
    bool hasInternalRecipe =
        (dynamicIngredientListData != null) && (dynamicMethodListData != null);

    //generate widgets from data
    if (hasInternalRecipe) {
      _addWithSpacer(RecipeIngredientList(dynamicIngredientListData), content);
      _addWithSpacer(RecipeMethodList(dynamicMethodListData), content);
    }


    if (dynamicExternalUrlData != null &&
        isURL(
          dynamicExternalUrlData,
          allowUnderscore: true,
          requireTld: false,
        )) {
      assert(dynamicExternalUrlData.runtimeType == String);
      _addWithSpacer(ExternalRecipeLink(dynamicExternalUrlData), content);
    }

    //if no recipe is specified
    if (dynamicExternalUrlData == null && !hasInternalRecipe) {
      _addWithSpacer(ErrorRecipeNotFound(), content);
    }

    if (dynamicNoteData != null) {
      assert(dynamicNoteData.runtimeType == String);
      content.add(RecipeNote(dynamicNoteData));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content,
    );
  }

  void _addWithSpacer(Widget toAdd, List<Widget> addTo) => addTo
    ..add(toAdd)
    ..add(
      SizedBox(
        height: 16.0,
      ),
    );
}
