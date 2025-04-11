import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'holiday_model.dart';

final holidayProvider = FutureProvider.family<List<Holiday>, int>((ref, year) async {
  final response = await http.get(
    Uri.parse('https://date.nager.at/api/v3/PublicHolidays/$year/US'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Holiday.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load holidays");
  }
});