import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'holiday_calendar_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Holiday Calendar',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HolidayCalendarScreen(), // Set this as the home screen
    );
  }
}