import 'dart:convert';

class Holiday {
  final String date;
  final String localName;
  final String countryCode;

  Holiday({required this.date, required this.localName, required this.countryCode});

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      date: json['date'],
      localName: json['localName'],
      countryCode: json['countryCode'],
    );
  }
}