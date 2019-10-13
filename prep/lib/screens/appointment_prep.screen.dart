import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:prep/utils/backend_provider.dart';
import 'package:prep/widgets/appointment_prep/category_card.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';

/// This widget displays a dual column grid containing at most 1 FAQ card, 1
/// Recipe card, n List cards and n Article cards. The grid is contained inside
/// a scrollable widget due to its expandable properties. The cards inside the
/// grid adjust their size to fit their contents.
class AppointmentPrep extends StatelessWidget {
  // Allow the _buildGrid to make sure only 1 FAQ and Recipe card is created
  bool seenRecipe;
  bool seenFAQ;

  /// Specifies the source of the data Stream, applies formatting to the grid
  /// and decides what to display on screen depending on the data received. An
  /// empty screen placeholder is displayed if the data is null or empty
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        key: Key('appointmentPrepScreen'),
        stream: BackendProvider.of(context).backend.prepCardsSnapshots,
        builder: (context, mapListSnapshot) {
          if (!mapListSnapshot.hasData) {
            return const Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(),
            );
          } else {
            if (mapListSnapshot.data != null &&
                mapListSnapshot.data.length > 0) {
              seenFAQ = false;
              seenRecipe = false;
              return StaggeredGridView.countBuilder(
                padding: EdgeInsets.all(7.5),
                crossAxisCount: 4,
                itemCount: mapListSnapshot.data.length,
                itemBuilder: (context, index) =>
                    _buildGrid(context, mapListSnapshot.data[index]),
                staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
              );
            } else {
              return EmptyScreenPlaceholder(
                  "There is no preparation information", "");
            }
          }
        });
  }

  /// Converts the data in [docIdDataMap] from a JSON format to a usable Map
  /// format. It cycles through the snapshot and builds the appropriate card
  /// for each parameter document.
  Widget _buildGrid(
      BuildContext context, Map<String, Map<String, dynamic>> docIdDataMap) {
    String docID = docIdDataMap.keys.first;
    Map<String, dynamic> dataMap = docIdDataMap[docIdDataMap.keys.first];

    if (dataMap['type'] == 'article' || dataMap['type'] == 'categoryList') {
      return CategoryCard(docID, dataMap['title'], dataMap['type']);
    } else {
      if (dataMap['type'] == 'faqs' && !seenFAQ) {
        seenFAQ = true;
        return CategoryCard(
            docID, "Frequently Asked Questions", dataMap['type']);
      }

      if (dataMap['type'] == 'recipe' && !seenRecipe) {
        seenRecipe = true;
        return CategoryCard(docID, "Suggested Recipes", dataMap['type']);
      }
    }

    return Container(
      padding: EdgeInsets.all(0),
    );
  }
}
