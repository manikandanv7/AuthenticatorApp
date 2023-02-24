import 'package:intl/intl.dart';

class Dateconversion {
  var today = DateFormat.yMd().format(DateTime.now()).toString();
  var yesterday = DateFormat.yMd()
      .format(DateTime.now().subtract(Duration(days: 1)))
      .toString();
  var others = DateFormat.yMd()
      .format(DateTime.now().subtract(Duration(days: 2)))
      .toString();

  getDate(String logindate) {
    var intDate = int.parse(logindate);
    var formattedDate = DateTime.fromMillisecondsSinceEpoch(intDate);
    var loggeddate = DateFormat.yMd().add_jm().format(formattedDate);

    return loggeddate.toString();
  }

  getTime(String logindate) {
    var intDate = int.parse(logindate);
    var formattedDate = DateTime.fromMillisecondsSinceEpoch(intDate);
    var loggeddate = DateFormat.yMd().format(formattedDate);
    if (loggeddate == today || loggeddate == yesterday)
      return DateFormat.jm().format(formattedDate).toString();
    else
      return DateFormat.yMd().add_jm().format(formattedDate);
  }

  convertdate(String logindate) {
    var intDate = int.parse(logindate);
    var formattedDate = DateTime.fromMillisecondsSinceEpoch(intDate);
    var loggeddate = DateFormat.yMd().format(formattedDate);
    // print(loggeddate + " The date");
    // print(today);
    // print(yesterday);

    return loggeddate.toString();
  }

  lastLogin(String data) {
    var intDate = int.parse(data);
    var formattedDate = DateTime.fromMillisecondsSinceEpoch(intDate);
    var loggeddate = DateFormat.yMd().format(formattedDate);
    if (today == loggeddate) {
      return 'Today ${DateFormat.jm().format(formattedDate)}';
    } else if (yesterday == loggeddate) {
      return 'yesterday ${DateFormat.jm().format(formattedDate)}';
    } else {
      return 'On ${DateFormat.yMd().add_jm().format(formattedDate).toString()}';
    }
  }
}
