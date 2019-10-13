import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:prep/utils/backend_provider.dart';
import 'package:prep/widgets/dashboard/help_dialog.dart';
import 'package:prep/widgets/dashboard/calendar.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';

/// This class is the backbone of the application. It sets the appointment code
/// (used by the rest of the system to retrieve data) in the backend class.
///
/// It contains various setup and security protocols that must be performed
/// asynchronously and before any other part of the application is accessed.
class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  // Firestore variables
  Widget cachedCalendar;
  List<Map<String, Map<String, dynamic>>> documentList;

  // Codes file variables
  String codeFileState;

  // Form validation variables
  TextEditingController codeController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool validationResultDb;
  bool validationResultFile;

  /// Subscribe the user to message notifications
  void _subscribeToNotifications(String appointmentID) {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.autoInitEnabled();
    firebaseMessaging.subscribeToTopic(appointmentID);
  }

  /// Determine if an appointment ID exists in the codes file
  bool _documentInCodeFile(String value) {
    return codeFileState.split(',').contains(value);
  }

  /// Determine if a code exists in the Firestore and is not used
  Future<bool> _isCodeInFirestoreNotUsed(String code) async {
    List<String> liveNotUsedIDs = new List();

    await BackendProvider.of(context).backend.appointmentCodes().then((query) {
      query.forEach((dataListMap) {
        String docId = dataListMap.keys.first;
        if (dataListMap[docId]['used'] == false) {
          liveNotUsedIDs.add(docId);
        }
      });
    });

    if (liveNotUsedIDs.contains(code)) {
      return true;
    } else {
      return false;
    }
  }

  /// Retrieve data from the database and determine if a calendar can be built.
  ///
  /// All the operations performed in this method are key for the validation of
  /// the data that is passed on to the rest of the application. All of them
  /// must be executed asynchronously as they require I/O access (the database
  /// and the device file manager). Having them together in one method
  /// ensures the state of the widget tree remains constant during their
  /// execution, thus avoiding concurrency bugs.
  Future<Widget> _validateCalendar() async {
    // Determine if the application is running on a fresh install or not
    bool fileExists = await BackendProvider.of(context).storage.fileExists();
    if (fileExists) {
    } else {
      await BackendProvider.of(context).storage.writeData(",");
    }

    // Load the contents of the local codes file into a variable
    codeFileState = await BackendProvider.of(context).storage.readData();

    // Read appointments from the database
    var querySnap =
        await BackendProvider.of(context).backend.appointmentCodes();
    if (querySnap == null) {
      return EmptyScreenPlaceholder(
          "Your calendar is empty", "Add some appointments");
    }

    // Retrieve appointment codes from the database
    documentList = querySnap;
    List<String> availableCodes = new List();
    documentList.forEach((docIdDataMap) {
      availableCodes.add(docIdDataMap.keys.first);
    });

    // Store all the codes in both the database and the codes file in a variable
    String newCodeFileState = "";
    codeFileState.split(',').forEach((code) {
      if (availableCodes.contains(code)) {
        newCodeFileState = newCodeFileState + code + ',';
      }
    });

    // Save the new sequence of codes in the codes file
    await BackendProvider.of(context).storage.writeData(newCodeFileState);
    codeFileState = newCodeFileState;

    return Calendar(codeFileState, documentList);
  }

  /// Builds the refresh and help buttons on the app bar, the floating action
  /// button for adding new codes and it displays a calendar when appropriate.
  ///
  /// The FutureBuilder used allows for the retrieval of all the appointments at
  /// once, as supposed to as a steam of documents. This is needed because the
  /// data needs to be analysed as a whole to determine which appointment cards
  /// to group under which date labels. The future caches the latest version of
  /// the calendar so it can be displayed while the latest version of it is
  /// being built.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Calendar"),
        actions: <Widget>[
          MakeHelpIcon(
              'This screen shows a calendar with all your due appointments. Tap on one of them to get more information.'),
          IconButton(
              key: Key('refreshButton'),
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              })
        ],
      ),
      body: FutureBuilder(
          future: _validateCalendar(),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return (cachedCalendar == null)
                    ? LinearProgressIndicator()
                    : Stack(children: <Widget>[
                        cachedCalendar,
                        LinearProgressIndicator()
                      ]);
              default:
                cachedCalendar = snapshot.data;
                return snapshot.data;
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context, builder: (_) => _NewAppointmentDialog(this));
          }),
    );
  }
}

/// This private class is contained in the same file as Dashboard because
/// they are closely related and share functionality. The reason behind their
/// split is to allow animations to be performed in _NewAppointmentDialog
/// without triggering the execution of expensive methods in Dashboard.
///
/// This class displays a form that allows the user to add new appointments to
/// their calendar. It validates such codes and provides feedback to the user.
class _NewAppointmentDialog extends StatefulWidget {
  final _DashboardState _parent;

  _NewAppointmentDialog(this._parent);

  @override
  State<StatefulWidget> createState() {
    return _NewAppointmentDialogState(_parent);
  }
}

class _NewAppointmentDialogState extends State<_NewAppointmentDialog> {
  bool loading = false;
  _DashboardState _parent; // needed to access its members

  _NewAppointmentDialogState(this._parent);

  /// Builds a simple form with a single input field and a submit button.
  ///
  /// Pressing the SUBMIT button triggers the execution of asynchronous
  /// functions used to validate the code entered. If the code is valid, a
  /// transaction is initialised to edit the database record and block further
  /// use of this appointment by anybody.
  ///
  /// Due to the asynchronous nature of the operations and the fact that they
  /// are used to maintain data consistency and security, they are kept in one
  /// private method to avoid concurrency bugs.
  ///
  /// The state of the widget tree is being changed before, during and after
  /// some operations make I/O requests so the sequence in which they are
  /// written needs to be altered with CAUTION.
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10.0),
      title: new Text("Enter appointment code"),
      content: SingleChildScrollView(
        child: Form(
          key: _parent._formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _parent.codeController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter a code";
                    } else {
                      if (_parent.validationResultFile) {
                        return "This appointment is in your calendar";
                      } else {
                        if (_parent.validationResultDb) {
                          // A return type of null is a successful validation
                          return null;
                        } else {
                          return "Invalid code";
                        }
                      }
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      child: RaisedButton(
                        color: Colors.indigo,
                        onPressed: () async {
                          if (loading) {
                            return null;
                          }

                          if (_parent.codeController.text.isEmpty) {
                            _parent._formKey.currentState.validate();
                          } else {
                            setState(() {
                              loading = true;
                            });

                            bool inFile = _parent._documentInCodeFile(
                                _parent.codeController.text);
                            bool inDatabase =
                                await _parent._isCodeInFirestoreNotUsed(
                                    _parent.codeController.text);

                            // The validator will succeed if the code is not
                            // already in the codes file and if it is not used
                            // in the database
                            _parent.validationResultDb = inDatabase;
                            _parent.validationResultFile = inFile;

                            // If the validator will succeed, start overwriting
                            // the used field already
                            if (inDatabase && !inFile) {
                              await BackendProvider.of(context)
                                  .backend
                                  .setAppointmentCodeUsed(
                                      _parent.codeController.text);
                            }

                            setState(() {
                              loading = false;
                            });

                            if (_parent._formKey.currentState.validate()) {
                              await BackendProvider.of(context)
                                  .storage
                                  .writeData(_parent.codeFileState +
                                      _parent.codeController.text +
                                      ',');

                              _parent.setState(() {
                                _parent._subscribeToNotifications(
                                    _parent.codeController.text);
                                _parent.codeController.text = "";
                              });

                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
                    Expanded(
                        child: Container(
                      alignment: Alignment.center,
                      child:
                          (loading) ? CircularProgressIndicator() : Container(),
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
