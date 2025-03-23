import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'holiday_model.dart';

final holidayProvider = FutureProvider<List<Holiday>>((ref) async {
  final response = await http.get(
    Uri.parse('https://date.nager.at/api/v3/PublicHolidays/2024/US'), // Change country code as needed
  );

  if (response.statusCode == 200) {
    final List<dynamic> data =  jsonDecode(response.body);
    return data.map((json) => Holiday.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load holidays");
  }
});
