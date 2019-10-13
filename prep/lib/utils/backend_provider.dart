import 'package:flutter/material.dart';

import 'package:prep/utils/backend.dart';
import 'package:prep/utils/storage.dart';

///Provides an instance of and object that implements BaseBackend to pass down a widget tree
///in order to avoid passing it down through the constructor.
class BackendProvider extends InheritedWidget {
  final BaseBackend backend;
  final Storage storage;

  BackendProvider(
      {Key key,
      @required Widget child,
      @required this.backend,
      this.storage})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static BackendProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(BackendProvider) as BackendProvider;
}
