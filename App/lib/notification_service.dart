import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Initialize timezone
    tz.initializeTimeZones();
    final String localTimeZone = tz.local.name;
    tz.setLocalLocation(tz.getLocation(localTimeZone));

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) async {
        final String? payload = response.payload;
        if (payload != null) {
          final parts = payload.split('|'); // Format: reminderId|message
          final int reminderId = int.parse(parts[0]);
          await _markReminderTaken(reminderId);
        }
      },
    );
  }

  /// Schedule a medicine reminder notification
  static Future<void> scheduleReminder({
    required int id,
    required int hour,
    required int minute,
    required String message,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      "💊 Medicine Reminder",
      message,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_channel',
          'Medicine Reminders',
          channelDescription: 'Reminder notifications for medicines',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          ticker: 'ticker',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: "$id|$message",
      matchDateTimeComponents: DateTimeComponents.time, // repeats daily
    );
  }

  /// Cancel a scheduled reminder
  static Future<void> cancelReminder(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Call Django backend to mark reminder as Taken
  static Future<void> _markReminderTaken(int reminderId) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = sh.getString('url')!;
      String lid = sh.getString('lid')!;

      await http.post(
        Uri.parse('$url/mark_reminder_taken/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'reminder_id': reminderId, 'lid': lid}),
      );
    } catch (e) {
      print("Error marking reminder as taken: $e");
    }
  }
}
