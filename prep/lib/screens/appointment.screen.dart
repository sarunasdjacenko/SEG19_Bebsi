import 'package:flutter/material.dart';

import 'package:prep/screens/appointment_info.screen.dart';
import 'package:prep/screens/appointment_prep.screen.dart';
import 'package:prep/screens/daily_checkups.screen.dart';
import 'package:prep/screens/messaging.screen.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/widgets/dashboard/help_dialog.dart';

/// This widget contains a bottom navigation bar and a dynamic body. The body
/// becomes one of the four pages that can be selected via the bottom navigation
/// bar. These include: Information, Preparation, Checkups and Dr. Chat
/// (messaging).
class Appointment extends StatefulWidget {
  final int index;

  /// The value of [index] determines which page is displayed when this widget
  /// is built.
  Appointment(this.index);

  @override
  State<StatefulWidget> createState() => _AppointmentState(index);
}

class _AppointmentState extends State<Appointment> {
  bool _unseenMessages = false;
  int _selectedIndex;
  AppointmentInfo _appointmentInfo;
  AppointmentPrep _appointmentPrep;
  DailyCheckups _dailyCheckups;
  MessagingScreen _messagingScreen;

  _AppointmentState(this._selectedIndex);

  /// Determines which page to display based on the given [index].
  Widget _getPage(int index) {
    switch (index) {
      case 1:
        return (_appointmentPrep != null)
            ? _appointmentPrep
            : _appointmentPrep = AppointmentPrep();
      case 2:
        return (_dailyCheckups != null)
            ? _dailyCheckups
            : _dailyCheckups = DailyCheckups();
      case 3:
        return (_messagingScreen != null)
            ? _messagingScreen
            : _messagingScreen = MessagingScreen();
      default:
        return (_appointmentInfo != null)
            ? _appointmentInfo
            : _appointmentInfo = AppointmentInfo();
    }
  }

  /// Determines which Help alert dialog to display based on the currently
  /// selected screen
  Widget _chooseHelpMenuToDisplay() {
    switch (_selectedIndex) {
      case 0:
        {
          return MakeHelpIcon(
              'This page offers relevant information about your appointment.');
        }
      case 1:
        {
          return MakeHelpIcon(
              'This page contains all the preparation information your doctor has provided for your appointment.');
        }
      case 2:
        {
          return MakeHelpIcon(
              "Let your doctor know how well you're preparing for your appointment by checking the daily instructions.");
        }
      case 3:
        {
          return MakeHelpIcon(
              "Chat directly with your doctor about pressing issues.");
        }
    }
  }

  /// Builds a scaffold with a body containing the selected page and a bottom
  /// navigation bar with links to each one of the four pages defined.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text(BackendProvider.of(context).backend.appointmentName),
          actions: <Widget>[_chooseHelpMenuToDisplay()]),
      body: Center(
        child: _getPage(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: Key('appointmentPage'),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.info), title: Text('Information')),
          BottomNavigationBarItem(
              icon: Icon(Icons.sort), title: Text('Preparation')),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_attributes), title: Text('Checkups')),
          BottomNavigationBarItem(
              icon: _buildChatIcon(), title: Text('Dr. Chat')),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        fixedColor: Colors.indigo,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /// Determines if the Dr. Chat tab icon should be white (no new messages) or
  /// red (new messages).
  Widget _buildChatIcon() {
    return (_selectedIndex == 3)
        ? Icon(Icons.chat)
        : StreamBuilder(
            stream:
                BackendProvider.of(context).backend.messagesSnapshots(false),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                snapshot.data.forEach((message) {
                  if (!message['seenByPatient']) _unseenMessages = true;
                });
              }

              return (_unseenMessages)
                  ? Icon(Icons.chat, color: Colors.red)
                  : Icon(Icons.chat);
            },
          );
  }

  /// Reloads the widget tree when an item of the bottom navigation bar is
  /// tapped. This causes the body of the enclosing scaffold to be redrawn and
  /// display the newly selected screen.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 3) _unseenMessages = false;
    });
  }
}
