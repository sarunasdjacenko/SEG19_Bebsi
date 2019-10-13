import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Performs setup work for the database that include timeStamp return settings.
/// Provides a reference to the live database object.
class DatabaseHandler {
  static Firestore db;

  /// Initialises the singleton
  static const DatabaseHandler _singleton = DatabaseHandler._internal();
  factory DatabaseHandler() => _singleton;
  const DatabaseHandler._internal();

  /// Initialises the database and applies the settings
  static void initDatabase() async {
    final FirebaseApp firebaseApp = await FirebaseApp.configure(
      name: "Prep",
      options: FirebaseOptions(
        googleAppID: (Platform.isIOS)
            ? "REDACTED"
            : "REDACTED",
        gcmSenderID: "REDACTED",
        apiKey: "REDACTED",
        projectID: "REDACTED",
      ),
    );
    db = Firestore(app: firebaseApp);
    await db.settings(timestampsInSnapshotsEnabled: true);
  }
}

/// Defines a backend type
abstract class BaseBackend {
  String appointmentID;
  String testID;
  String appointmentName;
  String location;
  DateTime dateTime;
  String doctorName;
  String contactNumber;
  Color color;

  /// Assigns a value to the class members. These are used by various screens
  /// in the application to avoid querying the database for data that has
  /// already been queried.
  void setBackendParams(newAppointmentID, newTestID, newAppointmentName,
      newLocation, newDateTime, newDoctorName, newContactNumber, newColor);

  /// Queries the database for all appointment codes found in the appointments
  /// collection
  Future<List<Map<String, Map<String, dynamic>>>> appointmentCodes() async {}

  /// Queries the database for all documents in the messages collection
  /// which is inside the appointments collection. Returns them in JSON format
  Stream<List<Map<String, dynamic>>> messagesSnapshots(bool setSeen);

  /// Adds a message in the messages collection.
  void sendMessage(String message);

  /// Flips the boolean 'answer' in an appointment dailyCheckup
  void flickCheckupSwitch(String documentId, String index, bool previousValue);

  /// Flips the boolean field 'used' in an appointment document
  Future<void> setAppointmentCodeUsed(String documentId) async {}

  /// Queries the database for all documents in the dailyCheckups collection
  /// which is inside the appointments collection. Returns them in JSON format
  /// mapping document ID to the document data.
  Stream<List<Map<String, Map<String, dynamic>>>> get dailyCheckupsSnapshots;

  /// Queries the database for all documents in the prepCards collection.
  /// Returns them in JSON format mapping document ID to the document data.
  Stream<List<Map<String, Map<String, dynamic>>>> get prepCardsSnapshots;

  /// Queries the database for all documents of type 'faqs'. Returns
  /// them in JSON format
  Stream<List<Map<String, dynamic>>> get faqSnapshots;

  /// Queries the database for all documents of type in the test collection.
  /// Returns them in a JSON format
  Stream<Map<String, dynamic>> get testSnapshots;

  /// Queries the database for all documents of type 'recipe'. Returns
  /// them in JSON format
  Stream<List<Map<String, dynamic>>> get recipeSnapshots;

  /// Queries the database for all documents of type 'article'. Returns
  /// them in JSON format
  Stream<Map<String, dynamic>> informationSnapshots(String documentId);

  /// Queries the database for all documents of type 'categoryList'. Returns
  /// them in JSON format
  Stream<Map<String, dynamic>> categoryListSnapshots(String documentId);
}

/// Implements the abstract class BaseBackend with an implementation of
/// Firebase's Cloud Firestore NoSQL database.
class FirestoreBackend implements BaseBackend {
  String appointmentID;
  String testID;
  String appointmentName;
  String location;
  DateTime dateTime;
  String doctorName;
  String contactNumber;
  Color color;

  /// Initialises the singleton
  static final FirestoreBackend _singleton = FirestoreBackend._internal();
  factory FirestoreBackend() => _singleton;
  FirestoreBackend._internal();

  /// Assigns a value to the class members. These are used by various screens
  /// in the application to avoid querying the database for data that has
  /// already been queried.
  void setBackendParams(newAppointmentID, newTestID, newAppointmentName,
      newLocation, newDateTime, newDoctorName, newContactNumber, newColor) {
    appointmentID = newAppointmentID;
    testID = newTestID;
    appointmentName = newAppointmentName;
    location = newLocation;
    dateTime = newDateTime;
    doctorName = newDoctorName;
    contactNumber = newContactNumber;
    color = newColor;
  }

  /// Returns querySnapshot in JSON format containing all appointment records
  /// in the appointments collection. The records map the document ID to it
  /// data and are placed inside a list.
  Future<List<Map<String, Map<String, dynamic>>>> appointmentCodes() async {
    QuerySnapshot querySnapshot = await _appointmentsCollection
        .where('expired', isEqualTo: false)
        .where('datetime',
            isGreaterThan: DateTime.now().subtract(Duration(days: 1)))
        .orderBy('datetime')
        .getDocuments();

    List<Map<String, Map<String, dynamic>>> futMap = querySnapshot.documents
        .map((docSnap) => {docSnap.documentID: docSnap.data})
        .toList();

    return futMap;
  }

  /// Provides a reference to the tests collection
  DocumentReference get _testReference =>
      DatabaseHandler.db.collection('tests').document(testID);

  /// Provides a reference to the appointments collection
  CollectionReference get _appointmentsCollection =>
      DatabaseHandler.db.collection('appointments');


  /// Provides a reference to an appointment document with the id
  /// [appointmentID]
  DocumentReference get _appointmentReference =>
      _appointmentsCollection.document(appointmentID);

  /// Provides a reference to the messages collection
  CollectionReference get _messagesCollection =>
      _appointmentReference.collection('messages');

  /// Returns all documents found in the messages collection inside an
  /// appointment document. It returns them in a JSON format. It sets messages
  /// which are unseen as 'seenByPatient'.
  Stream<List<Map<String, dynamic>>> messagesSnapshots(bool setSeen) =>
      _messagesCollection
          .orderBy('datetime', descending: false)
          .snapshots()
          .map((querySnapshot) => querySnapshot.documentChanges
              .map((docChange) {
                if (docChange.type == DocumentChangeType.added) {
                  DocumentSnapshot docSnapshot = docChange.document;
                  Map<String, dynamic> message = docSnapshot.data;
                  if (setSeen && !message['seenByPatient'])
                    docSnapshot.reference.updateData({'seenByPatient': true});
                  return message;
                }
              })
              .where((message) => message != null)
              .toList());

  /// Adds a message to the messages collection in an appointment document.
  void sendMessage(String message) => _messagesCollection.add({
        'content': message,
        'datetime': DateTime.now(),
        'isPatient': true,
        'seenByPatient': true,
        'seenByStaff': false,
      });

  /// Performs an operation that flips the 'answer' boolean field in an
  /// dailyCheckup document in an appointment's collection. The operation is not
  /// asynchronous in order to guarantee speed. It is not necessary to maintain
  /// data consistency here because the patient that own the appointment is the
  /// only one that is allowed to change this data.
  void flickCheckupSwitch(String documentId, String index, bool previousValue) {
    _appointmentReference
        .collection('dailyCheckups')
        .document(documentId)
        .updateData({
      // Toggles true/false for the daily checkup
      ('instructions.' + index + '.answer'): !previousValue,
      ('instructions.' + index + '.lastChecked'): DateTime.now(),
    });
  }

  /// Performs an asynchronous operation that flips the 'used' field of an
  /// appointment. The operation does not return until the data is reliably
  /// stored in the database as it uses Firebase transactions
  Future<void> setAppointmentCodeUsed(String documentId) async {
    DatabaseHandler.db.runTransaction((transaction) async {
      DocumentSnapshot freshSnap =
          await transaction.get(_appointmentsCollection.document(documentId));
      await transaction.update(freshSnap.reference, {
        'used': true
      });
    });
  }

  /// Returns all documents found in the dailyCheckups collection inside an
  /// appointment document. It returns them in a JSON format, mapping document
  /// IDs to their own data and storing them inside a list, as to simulate a
  /// querySnapshot object
  Stream<List<Map<String, Map<String, dynamic>>>> get dailyCheckupsSnapshots =>
      _appointmentReference
          .collection('dailyCheckups')
          .orderBy('daysBeforeTest', descending: true)
          .snapshots()
          .map((querySnap) => querySnap.documents
              .map((docSnap) => {docSnap.documentID: docSnap.data})
              .toList());

  /// Returns all documents found in the prepCards collection. It returns them
  /// in a JSON format, mapping document IDs to their own data and storing
  /// them inside a list, as to simulate a querySnapshot object
  Stream<List<Map<String, Map<String, dynamic>>>> get prepCardsSnapshots =>
      _testReference.collection('prepCards').snapshots().map((querySnap) =>
          querySnap.documents
              .map((docSnap) => {docSnap.documentID: docSnap.data})
              .toList());

  /// Returns all the documents in the prepCards collection that are of type
  /// 'faq'. It returns the document ID mapped to the data inside a list, as
  /// to mimic a querySnapshot object.
  Stream<List<Map<String, dynamic>>> get faqSnapshots => _testReference
      .collection('prepCards')
      .where('type', isEqualTo: 'faqs')
      .snapshots()
      .map((querySnap) =>
          querySnap.documents.map((docSnap) => docSnap.data).toList());

  /// Returns all test documents in a JSON format where the document ID is
  /// mapped to its data
  Stream<Map<String, dynamic>> get testSnapshots =>
      _testReference.snapshots().map((docSnap) => docSnap.data);

  /// Returns all the documents in the prepCards collection that are of type
  /// 'recipe'. It returns the document ID mapped to the data inside a list, as
  /// to mimic a querySnapshot object
  Stream<List<Map<String, dynamic>>> get recipeSnapshots => _testReference
      .collection('prepCards')
      .where('type', isEqualTo: 'recipe')
      .snapshots()
      .map((querySnap) =>
          querySnap.documents.map((docSnap) => docSnap.data).toList());

  /// Returns all the documents in the prepCards collection that are of type
  /// 'article'. It returns the document ID mapped to the data.
  Stream<Map<String, dynamic>> informationSnapshots(documentId) =>
      _testReference
          .collection('prepCards')
          .document(documentId)
          .snapshots()
          .map((docSnap) => docSnap.data);

  /// Returns all the documents in the prepCards collection that are of type
  /// 'categoryList'. It returns the document ID mapped to the data.
  Stream<Map<String, dynamic>> categoryListSnapshots(String documentId) =>
      _testReference
          .collection('prepCards')
          .document(documentId)
          .snapshots()
          .map((docSnap) => docSnap.data);
}