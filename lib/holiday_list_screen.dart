import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'holiday_provider.dart';

class HolidayListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holidayAsyncValue = ref.watch(holidayProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Holidays')),
      body: holidayAsyncValue.when(
        data: (holidays) => ListView.builder(
          itemCount: holidays.length,
          itemBuilder: (context, index) {
            final holiday = holidays[index];
            return Card(
              child: ListTile(
                title: Text(holiday.localName),
                subtitle: Text(holiday.date),
                trailing: Text(holiday.countryCode),
              ),
            );
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}