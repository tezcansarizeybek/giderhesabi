import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextFormWidget extends StatelessWidget {
  const TextFormWidget({Key? key, required this.controller, this.label, this.onChanged, this.border, this.textInputType, this.datePicker = false, this.validator})
      : super(key: key);
  final String? label;
  final InputBorder? border;
  final Function(String)? onChanged;
  final TextEditingController controller;
  final TextInputType? textInputType;
  final bool datePicker;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: TextFormField(
        decoration: InputDecoration(
          border: border ?? OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: label,
        ),
        validator: validator,
        readOnly: datePicker,
        onChanged: onChanged,
        controller: controller,
        keyboardType: textInputType,
        onTap: () async {
          if (datePicker) {
            var date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2030));
            if (date != null) {
              controller.text = DateFormat("dd-MM-yyyy").format(date);
            }
          }
        },
      ),
    );
  }
}
