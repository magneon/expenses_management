import 'package:intl/intl.dart';

class DateUtil {

  static String formatDate(String date, String formatIn, String formatOut) {
    DateFormat formatterIn = DateFormat(formatIn);
    DateFormat formatterOut = DateFormat(formatOut);

    return formatterOut.format(formatterIn.parse(date));
  }

}