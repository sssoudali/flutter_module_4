import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'holiday_provider.dart';
import 'holiday_model.dart';


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
      appBar: AppBar(title: Text('Calendar')),
      body: holidayAsyncValue.when(
        data: (holidays) {
          print("HolidayDataasdf="+_holidayEvents.toString());
          for (var holiday in holidays) {
            DateTime holidayDate = DateTime.parse(holiday.date);
            if (_holidayEvents.containsKey(holidayDate)) {
              _holidayEvents[holidayDate]!.add(holiday.localName);
            } else {
              _holidayEvents[holidayDate] = [holiday.localName];
            }
            
            setState(() {

  for (var holiday in holidays) {
    DateTime holidayDate = DateTime.parse(holiday.date);
    holidayDate = DateTime(holidayDate.year, holidayDate.month, holidayDate.day); 

    if (_holidayEvents.containsKey(holidayDate)) {
      _holidayEvents[holidayDate]!.add(holiday.localName);
    } else {
      _holidayEvents[holidayDate] = [holiday.localName];
    }
  }
});
          }
          return Column(
            children: [
              TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                calendarFormat: CalendarFormat.month,
                eventLoader: (day){
                DateTime normalizedDay = DateTime(day.year, day.month, day.day);
                return _holidayEvents[normalizedDay] ?? []; 
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(()
                  {
                    _focusedDay = focusedDay;
                    });
                },
              calendarBuilders:CalendarBuilders(
                 markerBuilder: (context, date, events)
                 {
                  if (events.isNotEmpty) {
      return Positioned(
        bottom: 5,
        child: Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red, 
          ),
        ),
      );
    }
    return null;
                 },
              ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount:  _holidayEvents[_focusedDay]?.length ?? 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_holidayEvents[_focusedDay]![index]),
                      leading: Icon(Icons.event, color: const Color.fromARGB(255, 33, 243, 117)),
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