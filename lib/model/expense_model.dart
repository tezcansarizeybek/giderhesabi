import 'dart:convert';

class Expense {
  Expense({
    required this.uuid,
    required this.description,
    required this.total,
    required this.date,
    required this.category,
    this.gpsx,
    this.gpsy,
  });

  String uuid;
  String description;
  double total;
  String date;
  String category;
  double? gpsx;
  double? gpsy;

  factory Expense.fromJson(String str) => Expense.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Expense.fromMap(Map<String, dynamic> json) => Expense(
        uuid: json["UUID"],
        description: json["DESCRIPTION"],
        total: json["TOTAL"],
        date: json["DATE"],
        category: json["CATEGORY"],
        gpsx: json["GPSX"],
        gpsy: json["GPSY"],
      );

  Map<String, dynamic> toMap() => {
        "UUID": uuid,
        "DESCRIPTION": description,
        "TOTAL": total,
        "DATE": date,
        "CATEGORY": category,
        "GPSX": gpsx,
        "GPSY": gpsy,
      };
}
