import 'package:flutter/material.dart';
import 'package:prep/utils/constants.dart';

///[ErrorRecipeNotFound] should be displayed when a given recipe data is incomplete or missing.
class ErrorRecipeNotFound extends StatelessWidget {
  //  ErrorRecipeNotFound({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          Constants.kErrorRecipeNotFound,
          style: Theme.of(context)
              .textTheme
              .subhead
              .copyWith(color: Theme.of(context).errorColor),
        ),
      );
}
