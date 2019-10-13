import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:prep/utils/constants.dart';

import 'package:prep/utils/document_data_provider.dart';
import 'package:prep/utils/misc_functions.dart';

///[RecipeCardHeader] is always displayed with every [RecipeCard]. 
///It loads the image for the recipe as well as the labels given by the [context]'s 
///[DocumentDataProvider].
class RecipeCardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 184.0,
      child: Stack(
        children: <Widget>[
          //The background image
          Positioned.fill(
            child: _loadRecipeImageOrDefault(context),
          ),
          //Recipe chips
          Positioned(
            bottom: 0.0,
            right: 6.0,
            child: SizedBox(
              width: (MediaQuery.of(context).size.width * 2.5 / 3.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                verticalDirection: VerticalDirection.up,
                direction: Axis.horizontal,
                spacing: 4.0,
                alignment: WrapAlignment.end,
                children: _buildRecipeLabels(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRecipeLabels(BuildContext context) {
    var dynamicLabels = DocumentDataProvider.of(context).documentData['labels'];

    if (dynamicLabels == null) return [];

    List<Chip> chipList = [];

    for (String label in convertDynamicListToStringList(dynamicLabels)) {
      chipList.add(
        _buildChipWithLabel(label, context),
      );
    }
    return chipList;
  }

  Chip _buildChipWithLabel(String label, BuildContext context) => Chip(
        label: Text(
          label,
          style: Theme.of(context).textTheme.body1,
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        backgroundColor: Theme.of(context).cardColor,
      );

  CachedNetworkImage _loadRecipeImageOrDefault(BuildContext context) {
    var backgroundImageUrl =
        DocumentDataProvider.of(context).documentData['backgroundImage'];
    var recipeType =
        DocumentDataProvider.of(context).documentData['recipeType'];

    backgroundImageUrl ??= '';
    recipeType ??= Constants.kDefaultRecipeType;
    if (recipeType != null) {
      assert(recipeType is String);
    }

    return CachedNetworkImage(
      imageUrl: backgroundImageUrl?.trim(),
      errorWidget: (context, url, err) =>
          _getDefaultImageFromRecipeType(recipeType),
      fadeInCurve: Curves.decelerate,
      fadeInDuration: Duration(microseconds: 300),
      fit: BoxFit.cover,
    );
  }

  Image _getDefaultImageFromRecipeType(String type) {
    const Map<String, String> imageOfType = {
      'salad': 'salad.jpg',
      'soup': 'soup.jpg',
      'vegetable': 'vegetable.jpg',
      'roast': 'roast.jpg',
      'stew': 'stew.jpg',
      'pizza': 'pizza.jpg',
      'pasta': 'pasta.jpg',
      'sandwich': 'sandwich.jpg',
      'wrap': 'wrap.jpg',
      'pie': 'pie.jpg',
      'fish': 'fish.jpg',
      'steak': 'steak.jpg',
      'beef': 'beef.jpg', 
      'chicken': 'chicken.jpg',
      'curry': 'curry.jpg',
      'eggs': 'eggs.jpg',
    };

    return _getAssetImage(
      (type != null) ? imageOfType[type.trim().toLowerCase()] : 'default.jpg',
    );
  }

  Image _getAssetImage(String name) =>
      Image.asset("assets/images/recipes/" + name, fit: BoxFit.cover);
}
