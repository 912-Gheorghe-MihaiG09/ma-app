import 'package:intl/intl.dart';

class Validator {
  static String? validateEmpty(String? s) {
    if (s == null || s.isEmpty) {
      return "* Required";
    }
    return null;
  }
  static String? validateDate(String? s) {
    if (s == null || s.isEmpty) {
      return "* Required";
    }
    if (!RegExp(r"^\d{4}-\d{2}-\d{2}$").hasMatch(s)) {
      return "Exp Date must be of format yyyy-MM-dd";
    }

    if(DateTime.tryParse(s) == null){
      return "Please enter a valid date";
    }
    return null;
  }
}
