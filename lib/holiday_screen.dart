import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'holiday_provider.dart';
import 'holiday_model.dart';

class HolidayScreen extends ConsumerStatefulWidget {
  @override
  _HolidayScreenState createState() => _HolidayScreenState();
}

class _HolidayScreenState extends ConsumerState<HolidayScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _holidayEvents = {};
  bool _holidaysLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchHolidays(_focusedDay.year);
  }

  void _fetchHolidays(int year) async {
    final holidays = await ref.read(holidayProvider(year).future);
    setState(() {
      _holidayEvents.clear();
      for (var holiday in holidays) {
        DateTime date = DateTime.parse(holiday.date);
        date = DateTime(date.year, date.month, date.day); // Normalize

        if (_holidayEvents.containsKey(date)) {
          _holidayEvents[date]!.add(holiday.localName);
        } else {
          _holidayEvents[date] = [holiday.localName];
        }
      }
      _holidaysLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Holiday Calendar')),
      body: !_holidaysLoaded
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  eventLoader: (day) {
                    DateTime normalized = DateTime(day.year, day.month, day.day);
                    return _holidayEvents[normalized] ?? [];
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                    _fetchHolidays(focusedDay.year);
                  },
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _buildEventList(),
                ),
              ],
            ),
    );
  }

  Widget _buildEventList() {
    final selected = _selectedDay != null
        ? DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)
        : null;

    final events = selected != null ? _holidayEvents[selected] ?? [] : [];

    if (events.isEmpty) {
      return Center(child: Text('No holidays on this day.'));
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.celebration),
          title: Text(events[index]),
        );
      },
    );
  }
}
