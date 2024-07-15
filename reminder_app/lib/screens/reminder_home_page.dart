import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/utils/notification_helper.dart';

class ReminderHomePage extends StatefulWidget {
  @override
  _ReminderHomePageState createState() => _ReminderHomePageState();
}

class _ReminderHomePageState extends State<ReminderHomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String _selectedDay = 'Monday';
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedActivity = 'Wake up';

  final List<String> _daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  final List<String> _activities = [
    'Wake up', 'Go to gym', 'Breakfast', 'Meetings', 'Lunch', 'Quick nap', 'Go to library', 'Dinner', 'Go to sleep'
  ];

  @override
  void initState() {
    super.initState();
    NotificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  }

  Future<void> _scheduleNotification() async {
    await NotificationHelper.scheduleNotification(
      flutterLocalNotificationsPlugin,
      _selectedDay,
      _selectedTime,
      _selectedActivity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: _selectedDay,
              onChanged: (newValue) {
                setState(() {
                  _selectedDay = newValue!;
                });
              },
              items: _daysOfWeek.map((day) {
                return DropdownMenuItem(
                  child: new Text(day),
                  value: day,
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Day of the week',
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (picked != null && picked != _selectedTime)
                  setState(() {
                    _selectedTime = picked;
                  });
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Time',
                  ),
                  controller: TextEditingController(
                    text: _selectedTime.format(context),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedActivity,
              onChanged: (newValue) {
                setState(() {
                  _selectedActivity = newValue!;
                });
              },
              items: _activities.map((activity) {
                return DropdownMenuItem(
                  child: new Text(activity),
                  value: activity,
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Activity',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _scheduleNotification();
              },
              child: Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
