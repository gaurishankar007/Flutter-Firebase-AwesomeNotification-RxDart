import 'package:flutter/material.dart';

class NotificationWeekAndTime {
  final int dayOfTheWeek;
  final TimeOfDay timeOfDay;

  NotificationWeekAndTime({
    required this.dayOfTheWeek,
    required this.timeOfDay,
  });
}

Future<NotificationWeekAndTime?> pickSchedule(BuildContext context) async {
  List<String> weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  TimeOfDay? timeOfDay;
  DateTime now = DateTime.now();
  int? selectedDay;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'I want to be reminded every:',
          textAlign: TextAlign.center,
        ),
        content: Wrap(
          alignment: WrapAlignment.center,
          spacing: 3,
          children: [
            for (int index = 0; index < weekdays.length; index++)
              ElevatedButton(
                onPressed: () {
                  selectedDay = index + 1;
                  Navigator.pop(context);
                },
                style: const ButtonStyle(),
                child: Text(weekdays[index]),
              ),
          ],
        ),
      );
    },
  );

  if (selectedDay != null && context.mounted) {
    timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        now.add(const Duration(minutes: 1)),
      ),
    );

    if (timeOfDay != null) {
      return NotificationWeekAndTime(dayOfTheWeek: selectedDay!, timeOfDay: timeOfDay);
    }
  }

  return null;
}
