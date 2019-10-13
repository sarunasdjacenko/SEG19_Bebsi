import 'package:url_launcher/url_launcher.dart';

/// Converts a list of [dynamic] objects into a list of [String] objects.
/// Returning a null object if the parameter list is null.
List<String> convertDynamicListToStringList(List<dynamic> dynamicList) {
  if (dynamicList == null) return [];

  List<String> stringList = [];
  for (dynamic dynamicItem in dynamicList) {
    stringList.add(dynamicItem.toString());
  }
  return stringList;
}

/// Launches a link parsed and displayed using the flutter_html library. An
/// error is returned if the link cannot be launched. Links must begin with
/// 'http' or 'https', otherwise they are considered untrustworthy and are not
/// accepted.
launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch url';
  }
}

/// Takes in a parameter of type [DateTime] returns the same data in the date
/// format DD M%M YYYY.
String dateFormatter(DateTime datetime) {
  if (datetime == null) {
    return "N/A";
  }

  const List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  String day = datetime.day.toString();
  String month = months[datetime.month - 1];
  String year = datetime.year.toString();

  return day + " " + month + " " + year;
}

/// Takes in a parameter of type [DateTime] returns the same data in the time
/// format HH : MM.
String timeFormatter(DateTime datetime) {
  if (datetime == null) {
    return "N/A";
  }

  String hour = (datetime.hour < 10)
      ? "0" + datetime.hour.toString()
      : datetime.hour.toString();
  String minute = (datetime.minute < 10)
      ? "0" + datetime.minute.toString()
      : datetime.minute.toString();

  return hour + " : " + minute;
}

/// Takes in a parameter of type [DateTime] returns a 3 letter abbreviation of
/// the month component. ie: March -> Mar.
String monthAbbreviation(DateTime datetime) {
  if (datetime == null) {
    return "N/A";
  }

  const List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  return months[datetime.month - 1].substring(0, 3);
}

/// Takes in a parameter of type [String] and checks whether it is null or not.
/// If so, it returns 'N/A', if not, it returns the original string. This
/// function is frequently used to null-check inputs of Text widgets.
String stringValidator(String string) {
  if (string == null) {
    return "N/A";
  } else {
    return string;
  }
}