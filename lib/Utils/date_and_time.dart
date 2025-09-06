import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/web.dart';

class DateAndTime {
  Logger logs = Logger(
      level: kReleaseMode ? Level.off : Level.debug,
      printer: PrettyPrinter(methodCount: 1, colors: true));

  String? monthAndYear(DateTime? time) {
    if (time == null) return null;

    String month = monthConversion(time.month);
    int year = time.year;
    return "$month $year";
  }

  String monthConversion(int? month) {
    String value = "";
    switch (month) {
      case 1:
        value = "january";
        break;
      case 2:
        value = "February";
        break;
      case 3:
        value = "March";
        break;
      case 4:
        value = "April";
        break;
      case 5:
        value = "May";
        break;
      case 6:
        value = "June";
        break;
      case 7:
        value = "July";
        break;
      case 8:
        value = "August";
        break;
      case 9:
        value = "September";
        break;
      case 10:
        value = "October";
        break;
      case 11:
        value = "November";
        break;
      case 12:
        value = "December";
        break;
      default:
        value = "";
    }

    return value;
  }

  String timeDifference(DateTime givenDateTime) {
    DateTime now = DateTime.now();

    final diff = now.difference(givenDateTime);

    logs.i(givenDateTime);

    if (diff.inSeconds < 60) {
      return "${diff.inSeconds} s";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes} m";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} h";
    } else if (diff.inDays < 7) {
      return "${diff.inDays} d";
    } else if (diff.inDays < 30) {
      return "${(diff.inDays / 7).floor()} w";
    } else if (diff.inDays < 365) {
      return "${(diff.inDays / 30).floor()} M";
    } else {
      return "${(diff.inDays / 365).floor()} Y";
    }
  }

  DateTime stringTimeStampToDateTime(String time) {
    var parts = time.replaceAll(RegExp(r'[^\d,]'), '').split(',');

    int seconds = int.parse(parts[0]);
    int nanoseconds = int.parse(parts[1]);

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000 + (nanoseconds / 1000000).round(),
      isUtc: true, // Firestore stores in UTC
    ).toLocal(); // Convert to your device's local timezone

    return dateTime;
  }

  String dateTimeToPostFormat(DateTime time) {
    logs.i("time stamp i got $time");
    return DateFormat("h:mm a , MMM dd, yyyy").format(time);
  }
}
