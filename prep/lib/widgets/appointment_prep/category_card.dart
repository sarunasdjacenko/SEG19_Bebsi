import 'package:flutter/material.dart';

import 'package:prep/screens/recipeList.screen.dart';
import 'package:prep/screens/information_parser.screen.dart';
import 'package:prep/screens/list_parser.screen.dart';
import 'package:prep/screens/faq_parser.screen.dart';
import 'package:prep/utils/misc_functions.dart';

/// Represents a document from querySnapshot of the prepCards collection as a
/// card containing an icon, a type and a title. Each card is used as a button
/// to navigate to a parser screen for each type of document.
class CategoryCard extends StatelessWidget {
  final String documentID;
  final String title;
  final String type;

  CategoryCard(this.documentID, this.title, this.type);

  /// Determines what screen to navigate to depending on the type of the card
  Future _navigate(dynamic context) {
    switch (type) {
      case "article":
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InformationParser(documentID, title)));
      case "categoryList":
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryListParser(documentID, title)));
      case "recipe":
        return Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecipeListScreen()));
      default:
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => FaqParser()));
    }
  }

  /// Determines which icon to display depending on the type of the card
  CircleAvatar _getIcon() {
    if (type == "categoryList") {
      return CircleAvatar(
        backgroundColor: Colors.blue[400],
        child: Icon(
          Icons.list,
          color: Colors.white,
        ),
      );
    } else if (type == "article") {
      return CircleAvatar(
        backgroundColor: Colors.deepPurple[400],
        child: Icon(
          Icons.info,
          color: Colors.white,
        ),
      );
    } else if (type == "faqs") {
      return CircleAvatar(
        backgroundColor: Colors.green[400],
        child: Icon(
          Icons.live_help,
          color: Colors.white,
        ),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.red[400],
        child: Icon(
          Icons.local_dining,
          color: Colors.white,
        ),
      );
    }
  }

  /// Determines which category name to display based on the category assigned
  /// to the document related to the card
  String _getCategoryName() {
    switch (type) {
      case "article":
        return "Article";
      case "categoryList":
        return "List";
      case "recipe":
        return "Recipe";
      default:
        return "FAQ";
    }
  }

  /// Builds a card containing an icon, a type, a title and an interactive
  /// InkWell component that enables navigation to other screens
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.5),
      child: Card(
        color: Colors.white,
        elevation: 3.0,
        child: InkWell(
            onTap: () {
              _navigate(context);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Text(
                    stringValidator(_getCategoryName()),
                    style: TextStyle(
                        color: Colors.grey[400], fontStyle: FontStyle.italic),
                  ),
                  leading: _getIcon(),
                ),
                ListTile(
                  title: Text(
                    stringValidator(title),
                    //maxLines: 3,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
