import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:prep/screens/dashboard.screen.dart';
import 'package:prep/utils/backend_provider.dart';
import 'package:prep/utils/backend.dart';
import 'package:prep/utils/constants.dart';
import 'package:prep/utils/storage.dart';

/// Performs basic setup upon startup. It initialises the database, locks the
/// device on portrait mode while inside the application and initialises the
/// Dashboard class.
void main() {
  Constants.kIsDebug = false;

  DatabaseHandler.initDatabase();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(
        BackendProvider(
          backend: FirestoreBackend(),
          storage: Storage(),
          child: MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.indigo,
            ),
            home: Dashboard(),
          ),
        ),
      );
    },
  );
}
