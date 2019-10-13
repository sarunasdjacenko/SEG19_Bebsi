import 'package:flutter/material.dart';

import 'package:prep/utils/misc_functions.dart';

/// Builds a widget that displays the name of an item as the title of the
/// expansion tile, as well as the description and sub-elements of the item as
/// formatted text underneath.
class DescriptiveExpansionTile extends StatelessWidget {
  final String category;
  final String description;
  List<Widget> columnChildren;
  final List<dynamic> items;

  /// Defines the layout of the descriptive tile based on the value of the
  /// parameters given. If no [description] is given, then no description text
  /// element is added, resulting in a shorter than usual drop down box.
  DescriptiveExpansionTile(this.category, this.description, this.items) {
    columnChildren = new List();

    if (description != null && description.isNotEmpty) {
      columnChildren.add(
        Text(
          description,
          key: Key('description'),
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );

      columnChildren.add(
        Divider(
          color: Colors.transparent,
        ),
      );
    }

    columnChildren.add(Text(
      _formatItemList(items),
      style: TextStyle(
        color: Colors.grey,
      ),
    ));
  }

  /// Formats a list of sub-elements into a string of elements separated by a
  /// bullet point character.
  String _formatItemList(List<dynamic> elementList) {
    String rawItems = "";

    if (items != null && items.isNotEmpty) {
      elementList.forEach((value) {
        rawItems += value + " " "•" + " ";
      });

      rawItems = rawItems.substring(0, rawItems.length - 3);
    }

    return rawItems;
  }

  /// Builds the descriptive expansion tile widget providing the item name as
  /// the title and the list of widget children formatted in the constructor as
  /// the children
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Card(
        elevation: 3.0,
        child: ExpansionTile(
          title: Text(stringValidator(category)),
          children: <Widget>[
            ListTile(
              title: Container(
                key: Key('listContainer'),
                padding: EdgeInsets.only(right: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: columnChildren,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
