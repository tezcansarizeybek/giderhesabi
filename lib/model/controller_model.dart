import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ControllerModel {
  TextEditingController description = TextEditingController();
  TextEditingController total = TextEditingController();
  TextEditingController date = TextEditingController(text: DateFormat("dd-MM-yyyy").format(DateTime.now()));
  TextEditingController category = TextEditingController();
  double? gpsX;
  double? gpsY;
}
