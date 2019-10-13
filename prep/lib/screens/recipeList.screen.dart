import 'package:flutter/material.dart';

import 'package:prep/utils/backend_provider.dart';
import 'package:prep/widgets/recipe/recipe_card.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';

import 'package:prep/utils/constants.dart';

///[RecipeListScreen] displays a screen of the test's Recipes as a list of [RecipeCards].
class RecipeListScreen extends StatelessWidget {
  static const String _appBarTitle = "Suggested Recipes";
  static const Widget _loadingWidget = Center(
    child: Text("Loading recipes..."),
  );
  static String _errorMessagePrefix = 'Error while loading recipes:';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),
      body: StreamBuilder(
        stream: BackendProvider.of(context).backend.recipeSnapshots,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return EmptyScreenPlaceholder(
              Constants.kNoRecipesFoundTitle,
              Constants.kNoRecipesFoundSubtitle,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loadingWidget;
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(_errorMessagePrefix + snapshot.error),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemBuilder: (_, index) => RecipeCard(
                  data: snapshot.data[index],
                ),
            itemCount: snapshot.data.length,
          );
        },
      ),
    );
  }
}
