import 'package:flutter/material.dart';

import 'package:prep/utils/document_data_provider.dart';
import 'package:prep/widgets/recipe/recipe_card_body.dart';
import 'package:prep/widgets/recipe/recipe_card_header.dart';

///The [RecipeCard] shows a Recipe to the user.
///It displays all infomation given in [data] as long as
///it is valid as a [Card]. It is comprised of [RecipeCard] subwidgets each responsible
///for some component of the card.
///
///The [RecipeCard] prvides a [DocumentDataProvider] to use by its subwidget in the [context].
class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> data;

  RecipeCard({@required this.data});

  @override
  Widget build(BuildContext context) {
    return DocumentDataProvider(
      documentData: data,
      child: Container(
        padding: EdgeInsets.only(bottom: 5.0),
        width: MediaQuery.of(context).size.width,
        child: Material(
          child: Card(
            elevation: 3.0,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                RecipeCardHeader(),
                RecipeCardBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
