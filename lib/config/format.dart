import 'package:intl/intl.dart';

import 'config.dart';

String? formatDateToHourAndMinutes(DateTime? date){
  return date != null
  ? date.hour.toString() + ":" + (date.minute != 0 ? date.minute.toString() : "00")
  : "";
}

/// Formats a DateTime value to a String showing the Day 
/// e.g: "Joi, 9 Iunie"
String? formatDateToDay(DateTime? date){
  return date != null
  ? kWeekdays[DateFormat('EEEE').format(date).substring(0,3)]! + ", " + date.day.toString() + " " + kMonths[date.month-1]
  : "";
}
