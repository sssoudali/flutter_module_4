import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'holiday_provider.dart';

class HolidayCalendarScreen extends ConsumerStatefulWidget {
  @override
  _HolidayCalendarScreenState createState() => _HolidayCalendarScreenState();
}

class _HolidayCalendarScreenState extends ConsumerState<HolidayCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<String>> _holidayEvents = {};

  @override
  Widget build(BuildContext context) {
    final holidayAsyncValue = ref.watch(holidayProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Holiday Calendar')),
      body: holidayAsyncValue.when(
        data: (holidays) {
          _holidayEvents = {
            for (var holiday in holidays)
              DateTime.parse(holiday.date): [holiday.localName]
          };

          return TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            eventLoader: (day) => _holidayEvents[day] ?? [],
            onDaySelected: (selectedDay, focusedDay) {
              setState(() => _focusedDay = focusedDay);
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}