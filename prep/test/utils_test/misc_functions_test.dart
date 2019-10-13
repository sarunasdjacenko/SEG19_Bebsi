import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import 'package:prep/utils/misc_functions.dart';

void main() {
  group('Dates are formatted as dd mm yyyy', () {
    List<Map<String, dynamic>> dateTimeList = new List();

    dateTimeList.add({
      "rawDate": DateTime(2019, 1, 1, 1, 0, 0, 0, 0),
      "stringDate": "1 January 2019"
    });

    dateTimeList.add({
      "rawDate": DateTime(2019, 1, 1, 1, 1, 1, 1, 1),
      "stringDate": "1 January 2019"
    });

    dateTimeList.add({
      "rawDate": DateTime(2000, 12, 12, 12, 0, 0, 0, 0),
      "stringDate": "12 December 2000"
    });

    dateTimeList.add({
      "rawDate": DateTime(2014, 5, 6, 7, 40, 30, 3, 12),
      "stringDate": "6 May 2014"
    });

    dateTimeList.add({
      "rawDate": DateTime(2024, 11, 2, 10, 0, 0, 0, 5),
      "stringDate": "2 November 2024"
    });

    dateTimeList.add({"rawDate": null, "stringDate": "N/A"});

    dateTimeList.forEach((map) {
      test('Test ' + (dateTimeList.indexOf(map) + 1).toString(), () {
        expect(dateFormatter(map['rawDate']), map['stringDate']);
      });
    });
  });

  group('Times are formatted as hh : mm', () {
    List<Map<String, dynamic>> timeList = new List();

    timeList.add({
      "rawTime": DateTime(2019, 1, 1, 0, 0, 0, 0, 0),
      "stringTime": "00 : 00"
    });

    timeList.add({
      "rawTime": DateTime(2019, 1, 1, 4, 0, 1, 1, 1),
      "stringTime": "04 : 00"
    });

    timeList.add({
      "rawTime": DateTime(2000, 12, 12, 12, 0, 0, 0, 0),
      "stringTime": "12 : 00"
    });

    timeList.add({
      "rawTime": DateTime(2014, 5, 6, 15, 0, 0, 0, 0),
      "stringTime": "15 : 00"
    });

    timeList.add({
      "rawTime": DateTime(2024, 11, 2, 24, 0, 0, 0, 0),
      "stringTime": "00 : 00"
    });

    timeList.add({
      "rawTime": DateTime(2019, 1, 1, 0, 30, 0, 0, 0),
      "stringTime": "00 : 30"
    });

    timeList.add({
      "rawTime": DateTime(2019, 1, 1, 7, 30, 1, 1, 1),
      "stringTime": "07 : 30"
    });

    timeList.add({
      "rawTime": DateTime(2000, 12, 12, 12, 25, 0, 0, 0),
      "stringTime": "12 : 25"
    });

    timeList.add({
      "rawTime": DateTime(2014, 5, 6, 16, 45, 0, 0, 0),
      "stringTime": "16 : 45"
    });

    timeList.add({
      "rawTime": DateTime(2024, 11, 2, 23, 59, 0, 0, 0),
      "stringTime": "23 : 59"
    });

    timeList.add({"rawTime": null, "stringTime": "N/A"});

    timeList.forEach((map) {
      test('Test ' + (timeList.indexOf(map) + 1).toString(), () {
        expect(timeFormatter(map['rawTime']), map['stringTime']);
      });
    });
  });

  group('Month abbreviations are the first three letter of the month name', () {
    List<Map<String, dynamic>> dateTimeList = new List();

    dateTimeList.add(
        {"rawDate": DateTime(2019, 1, 1, 1, 0, 0, 0, 0), "monthAbr": "Jan"});

    dateTimeList.add(
        {"rawDate": DateTime(2019, 1, 1, 1, 1, 1, 1, 1), "monthAbr": "Jan"});

    dateTimeList.add(
        {"rawDate": DateTime(2000, 12, 12, 12, 0, 0, 0, 0), "monthAbr": "Dec"});

    dateTimeList.add(
        {"rawDate": DateTime(2014, 5, 6, 7, 40, 30, 3, 12), "monthAbr": "May"});

    dateTimeList.add(
        {"rawDate": DateTime(2024, 11, 2, 10, 0, 0, 0, 5), "monthAbr": "Nov"});

    dateTimeList.add({"rawDate": null, "monthAbr": "N/A"});

    dateTimeList.forEach((map) {
      test('Test ' + (dateTimeList.indexOf(map) + 1).toString(), () {
        expect(monthAbbreviation(map['rawDate']), map['monthAbr']);
      });
    });
  });

  group('', () {
    List<Map<List<dynamic>, List<String>>> listPairs = new List();

    listPairs.forEach((list) {
      test('Test ' + (listPairs.indexOf(list) + 1).toString(), () {
        expect(true, true);
      });
    });
  });

  group('convertDynamicListToStringList:', () {
    const List<List<dynamic>> parameters = [
      <dynamic>['string1'],
      <dynamic>[Object()],
      <dynamic>[5, 0, -1, 0.0],
      <dynamic>[true, false],
      <dynamic>[null],
      <dynamic>[],
    ];

    parameters.forEach((parameter) {
      test("this function should convert elements of $parameter list to String",
          () {
        List<String> shouldBeListOfString =
            convertDynamicListToStringList(parameter);

        expect(shouldBeListOfString, TypeMatcher<List<String>>());

        for (var shouldBeString in shouldBeListOfString) {
          expect(shouldBeString, TypeMatcher<String>());
        }
      });
    });
  });

  group('String validator prevents null outputs from a String input', () {
    List<Map<String, String>> stringList = new List();

    stringList.add({
      "stringIn": 'Hello',
      "stringOut": "Hello"
    });

    stringList.add({
      "stringIn": null,
      "stringOut": "N/A"
    });

    stringList.add({
      "stringIn": 'H e l l o',
      "stringOut": "H e l l o"
    });

    stringList.add({
      "stringIn": 'HELLO',
      "stringOut": "HELLO"
    });

    stringList.forEach((map) {
      test('Test ' + (stringList.indexOf(map) + 1).toString(), () {
        expect(stringValidator(map['stringIn']), map['stringOut']);
      });
    });
  });
}
