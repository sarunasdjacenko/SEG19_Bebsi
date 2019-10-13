import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Provides methods that allows the reading and writing of files in a device's
/// application directory.
///
/// The methods are designed to work cross platform, however, they must be
/// running in a compatible environment (mobile platform supported by the
/// flutter framework). This is the reason why this class is difficult to test.
/// The testing framework must provide a compatible environment for the class'
/// members to run.
class Storage {

  /// Returns the platform specific application documents directory path. This
  /// is also known as the data directory of an application.
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  /// Returns the file 'prepApCode.txt' from the data directory or null if the
  /// file does not exist.
  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/prepApCode.txt');
  }

  /// Returns the contents of the file 'prepApCode.txt' from the data directory.
  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();
      return body;
    } catch (e) {
      return e.toString();
    }
  }

  /// Overrides the contents of the file with the parameter [data].
  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }

  /// Determines whether the file 'prepApCode.txt' exists in the data directory.
  Future<bool> fileExists() async {
    String filePath = await localPath;
    return FileSystemEntity.typeSync(filePath + "/prepApCode.txt") !=
        FileSystemEntityType.notFound;
  }
}