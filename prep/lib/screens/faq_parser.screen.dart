import 'package:flutter/material.dart';

import 'package:prep/utils/backend_provider.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/widgets/faq_parser/faq_expansion_tile.dart';

/// Displays a column of faq expansion tiles, each containing a question, an
/// answer and a maximum of 2 shortcut buttons to other screens.
class FaqParser extends StatelessWidget {

  /// This method is called with every document received from the database. It
  /// creates and expansion tile for each entry.
  Widget _buildListItem(BuildContext context, Map<String, dynamic> dataMap) {
    return FaqExpansionTile(dataMap['question'], dataMap['answer'],
        dataMap['chatShortcut'], dataMap['informationShortcut']);
  }

  /// Builds the page based on the state of the Stream of data received from the
  /// database. If the data is present, a column of FAQs is displayed, otherwise
  /// an empty screen placeholder is displayed. A loading indicator is displayed
  /// while loading new data
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("FAQ"),
      ),
      body: StreamBuilder(
        stream: BackendProvider.of(context).backend.faqSnapshots,
        builder: (context, mapListSnapshot) {
          if (!mapListSnapshot.hasData) {
            return const Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(),
            );
          } else {
            if (mapListSnapshot.data != null &&
                mapListSnapshot.data.length > 0) {
              return ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: mapListSnapshot.data.length,
                itemBuilder: (context, index) =>
                    _buildListItem(context, mapListSnapshot.data[index]),
              );
            } else {
              return EmptyScreenPlaceholder(
                  "There are no FAQs", "Contact your doctor for help");
            }
          }
        },
      ),
    );
  }
}
