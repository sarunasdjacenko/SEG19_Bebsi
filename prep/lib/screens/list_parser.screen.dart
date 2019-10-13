import 'package:flutter/material.dart';

import 'package:prep/utils/backend_provider.dart';
import 'package:prep/widgets/list_parser/description_expansion_tile.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/utils/misc_functions.dart';

/// Displays one list of items about a specific category. Items are displayed in
/// a drop down tile format. They can contain a title, a description and a list
/// of elements.
class CategoryListParser extends StatelessWidget {
  final String documentId;
  final String _title;

  CategoryListParser(this.documentId, this._title);

  /// Evaluates the data read from the database and decides what to build to be
  /// displayed on screen. If the data is valid, a list of categories will be
  /// displayed, else, an empty screen placeholder will be displayed. A loading
  /// indicator is displayed while loading new data
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(stringValidator(_title)),
      ),
      body: StreamBuilder(
          stream: BackendProvider.of(context)
              .backend
              .categoryListSnapshots(documentId),
          builder: (context, dataSnapshot) {
            if (!dataSnapshot.hasData) {
              return const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(),
              );
            } else {
              if (dataSnapshot.data['maps'] != null &&
                  dataSnapshot.data['maps'].length > 0) {
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: 1,
                  itemBuilder: (context, index) =>
                      _buildDropDownList(context, dataSnapshot.data),
                );
              } else {
                return EmptyScreenPlaceholder("No items in this list", "");
              }
            }
          }),
    );
  }

  /// Retrieves the field containing the displayable items of each document
  /// in the database and creates an expansion tile displaying their data.
  Widget _buildDropDownList(
      BuildContext context, Map<String, dynamic> dataMap) {
    List<Widget> dropDowns = new List();

    // Retrieves the field containing all the items of the parameter document
    List<dynamic> mappedData = dataMap['maps'];

    // Constructs a descriptive expansion tile for each item
    mappedData.forEach((value) {
      dropDowns.add(DescriptiveExpansionTile(
          value['name'], value['description'], value['list']));
    });

    return Column(key: Key("listsColumn"), children: dropDowns);
  }
}
