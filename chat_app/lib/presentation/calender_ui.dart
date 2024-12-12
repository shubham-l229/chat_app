import 'package:chat_app/presentation/calender.dart';
import 'package:flutter/material.dart';

class CalenderUi extends StatefulWidget {
  const CalenderUi({super.key});

  @override
  State<CalenderUi> createState() => _CalenderUiState();
}

class _CalenderUiState extends State<CalenderUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: ElevatedButton(
          onPressed: () async {
            await NotificationService().initNotifications();
            await NotificationService().scheduledNotification(
              title: 'Reminder',
              body: 'Your event is scheduled',
              scheduledTime: DateTime.now().add(Duration(minutes: 1)),
            );
          },
          child: Text('Schedule in Calendar'),
        ),
      )),
    );
  }
}
