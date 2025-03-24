import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'holiday_provider.dart';


class HolidayScreen extends ConsumerStatefulWidget {
  @override
  _HolidayScreenState createState() => _HolidayScreenState();
}

class _HolidayScreenState extends ConsumerState<HolidayScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _holidayEvents = {};

  @override
  Widget build(BuildContext context) {
    final holidayAsyncValue = ref.watch(holidayProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Holiday Calendar')),
      body: holidayAsyncValue.when(
        data: (holidays) {
          _holidayEvents.clear(); // Reset events before updating

          for (var holiday in holidays) {
            DateTime holidayDate = DateTime.parse(holiday.date);
            holidayDate = DateTime(holidayDate.year, holidayDate.month, holidayDate.day); // Normalize date
            
            if (_holidayEvents.containsKey(holidayDate)) {
              _holidayEvents[holidayDate]!.add(holiday.localName);
            } else {
              _holidayEvents[holidayDate] = [holiday.localName];
            }
          }

          return Column(
            children: [
              Expanded( 
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  calendarFormat: CalendarFormat.month,
                  eventLoader: (day) {
                    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
                    return _holidayEvents[normalizedDay] ?? [];
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _selectedDay == null
                    ? "Select a date to see holidays"
                    : "Holidays on ${_selectedDay!.toLocal().toString().split(' ')[0]}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _selectedDay != null ? (_holidayEvents[_selectedDay] ?? []).length : 0,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        leading: Icon(Icons.event, color: Colors.blue),
                        title: Text(
                          _holidayEvents[_selectedDay]![index],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
