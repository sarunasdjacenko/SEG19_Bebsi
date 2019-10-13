import 'package:flutter/material.dart';
import 'package:prep/utils/backend_provider.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/utils/misc_functions.dart';

/// This widget displays a scrollable list of all daily checkups scheduled for
/// a specific appointment. Each one contains the date of completion, an
/// indicator of how many days are left until the day of the appointment, a list
/// of checkup instructions and a switch per instruction to mark them as done.
class DailyCheckups extends StatelessWidget {

  /// Returns a formatted date icon that contains a date in the format of a day
  /// number and a 3 letter month abbreviation. If the date detected is the day
  /// of the appointment, the background of the icon becomes red.
  CircleAvatar _getCheckupIcon(int daysBeforeTest, BuildContext context) {
    final BaseBackend backend = BackendProvider.of(context).backend;

    return CircleAvatar(
      key: Key('dateIcon'),
      backgroundColor:
          (daysBeforeTest == 0) ? Colors.red[400] : Colors.indigo[400],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            stringValidator(backend.dateTime
                .subtract(Duration(days: daysBeforeTest))
                .day
                .toString()),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              //fontWeight: FontWeight.bold
            ),
          ),
          Text(
            monthAbbreviation(backend.dateTime),
            style: TextStyle(color: Colors.white, fontSize: 10.0),
          ),
        ],
      ),
    );
  }

  /// Returns the title of a checkup expansion tile based on how many days are
  /// left before the appointment.
  Text _getCheckupText(int daysBeforeTest) {
    switch (daysBeforeTest) {
      case 1:
        return Text("Your appointment is tomorrow");
      case 0:
        return Text("Your appointment is today!");
      default:
        return Text(daysBeforeTest.toString() + " days to your appointment");
    }
  }

  /// Converts the input data in JSON format to a more usable map. It builds the
  /// body of a daily checkup containing a list of instructions and their
  /// corresponding switch. The switches trigger an event that flips the boolean
  /// value of their instruction in the database
  Widget _buildCheckupBody(
      BuildContext context, Map<String, Map<String, dynamic>> docIdDataMap) {
    // digesting data in Firebase JSON format
    List<Widget> instructionWidgets = new List();

    String docID = docIdDataMap.keys.first;
    Map<String, dynamic> dataMap = docIdDataMap[docID];

    Map<dynamic, dynamic> dynamicInstructions = dataMap['instructions'];

    // building the daily checkup body
    if (dynamicInstructions != null) {
      dynamicInstructions.forEach((index, map) {
        Map<dynamic, dynamic> checkupMap = map;

        instructionWidgets.add(Column(
          children: <Widget>[
            Divider(),
            ListTile(
                leading: Container(
                  //color: Colors.red,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 23.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 14.0,
                      child: Text(
                        stringValidator((int.parse(index) + 1).toString()),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  stringValidator(checkupMap['question']),
                ),
                trailing: Container(
                  //color: Colors.red,
                  child: Switch(
                    activeColor: Colors.green[500],
                    activeTrackColor: Colors.green[100],
                    value: checkupMap['answer'],
                    onChanged: (_) {
                      BackendProvider.of(context).backend.flickCheckupSwitch(
                          docID, index, checkupMap['answer']);
                    },
                  ),
                ))
          ],
        ));
      });
    }

    instructionWidgets.add(Divider(
      height: 9.0,
      color: Colors.white,
    ));

    // building the expansion tile
    return Container(
      padding: EdgeInsets.only(right: 10.0, left: 10.0, bottom: 5.0),
      child: Card(
        elevation: 3.0,
        child: ExpansionTile(
            initiallyExpanded: true,
            leading: _getCheckupIcon(dataMap['daysBeforeTest'], context),
            title: _getCheckupText(dataMap['daysBeforeTest']),
            children: instructionWidgets),
      ),
    );
  }

  /// Builds a column widget containing a list of daily checkup expansion tiles
  /// if the data is valid, otherwise, an empty screen placeholder is displayed.
  /// A StreamBuilder allows for data being stored live in the database and
  /// having the app react to it immediately and update itself.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      key: Key('dailyCheckupsScreen'),
      stream: BackendProvider.of(context).backend.dailyCheckupsSnapshots,
      builder: (context, mapListSnapshot) {
        if (!mapListSnapshot.hasData) {
          return const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(),
          );
        } else {
          if (mapListSnapshot.data != null && mapListSnapshot.data.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              itemCount: mapListSnapshot.data.length,
              itemBuilder: (context, index) =>
                  _buildCheckupBody(context, mapListSnapshot.data[index]),
            );
          } else {
            return EmptyScreenPlaceholder("There are no checkups", "");
          }
        }
      },
    );
  }
}
