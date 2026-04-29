// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'notification_service.dart';
//
// class MedicineReminder extends StatefulWidget {
//   const MedicineReminder({super.key});
//
//   @override
//   State<MedicineReminder> createState() => _MedicineReminderState();
// }
//
// class _MedicineReminderState extends State<MedicineReminder> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _timeController = TextEditingController();
//   final TextEditingController _messageController = TextEditingController();
//
//   TimeOfDay? _selectedTime;
//
//   List<int> reminderIds = [];
//   List<String> times = [];
//   List<String> messages = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchReminders();
//   }
//
//   @override
//   void dispose() {
//     _timeController.dispose();
//     _messageController.dispose();
//     super.dispose();
//   }
//
//   // ================= TIME PICKER =================
//   Future<void> _selectTime() async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//
//     if (picked != null) {
//       setState(() {
//         _selectedTime = picked;
//         _timeController.text = picked.format(context);
//       });
//     }
//   }
//
//   // ================= ADD REMINDER =================
//   Future<void> setReminder() async {
//     if (!_formKey.currentState!.validate() || _selectedTime == null) return;
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url')!;
//     String lid = sh.getString('lid')!;
//
//     String formattedTime =
//         "${_selectedTime!.hour.toString().padLeft(2, '0')}:"
//         "${_selectedTime!.minute.toString().padLeft(2, '0')}:00";
//
//     var response = await http.post(
//       Uri.parse('$url/set_medicine_reminder/'),
//       body: {
//         'lid': lid,
//         'time': formattedTime,
//         'message': _messageController.text,
//       },
//     );
//
//     var data = jsonDecode(response.body);
//
//     if (data['status'] == 'success') {
//       int id = data['data']['id'];
//       String time = data['data']['time'];
//       String msg = data['data']['message'];
//
//       // 🔔 Schedule system notification
//       final parts = time.split(":");
//       NotificationService.scheduleReminder(
//         id: id,
//         hour: int.parse(parts[0]),
//         minute: int.parse(parts[1]),
//         message: msg,
//       );
//
//       _timeController.clear();
//       _messageController.clear();
//       _selectedTime = null;
//
//       fetchReminders();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Reminder set successfully")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(data['message'])),
//       );
//     }
//   }
//
//   // ================= FETCH REMINDERS =================
//   Future<void> fetchReminders() async {
//     print('called');
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url')!;
//     String lid = sh.getString('lid')!;
//
//     var response = await http.post(
//       Uri.parse('$url/view_medicine_reminders/'),
//       body: {'lid': lid},
//     );
//
//     var data = jsonDecode(response.body);
//
//     if (data['status'] == 'success') {
//       reminderIds.clear();
//       times.clear();
//       messages.clear();
//
//       for (var r in data['data']) {
//         int id = r['id'];
//         String time = r['time']; // HH:MM
//         String msg = r['message'];
//
//         reminderIds.add(id);
//         times.add(time);
//         messages.add(msg);
//
//         // 🔔 Schedule system notification
//         final parts = time.split(":");
//         NotificationService.scheduleReminder(
//           id: id,
//           hour: int.parse(parts[0]),
//           minute: int.parse(parts[1]),
//           message: msg,
//         );
//       }
//
//       setState(() {});
//     }
//   }
//
//   // ================= DELETE REMINDER =================
//   Future<void> deleteReminder(int reminderId) async {
//     // 🔔 Cancel system notification
//     NotificationService.cancelReminder(reminderId);
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url')!;
//
//     await http.post(
//       Uri.parse('$url/delete_reminder/'),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({'reminder_id': reminderId}),
//     );
//
//     fetchReminders();
//   }
//
//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Medicine Reminder"),
//         backgroundColor: Colors.pink,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Set Reminder",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _timeController,
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       labelText: "Time",
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.access_time),
//                         onPressed: _selectTime,
//                       ),
//                     ),
//                     validator: (v) => v!.isEmpty ? "Please select time" : null,
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(
//                       labelText: "Medicine details",
//                     ),
//                     validator: (v) => v!.isEmpty ? "Enter medicine details" : null,
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: setReminder,
//                     child: const Text("Set Reminder"),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 20),
//             const Text(
//               "Your Reminders",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//
//             Expanded(
//               child: ListView.builder(
//                 itemCount: reminderIds.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: ListTile(
//                       title: Text(messages[index]),
//                       subtitle: Text("Time: ${times[index]}"),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () {
//                           deleteReminder(reminderIds[index]);
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class MedicineReminder extends StatefulWidget {
  const MedicineReminder({super.key, required this.title});

  final String title;

  @override
  State<MedicineReminder> createState() => _MedicineReminderState();
}

class _MedicineReminderState extends State<MedicineReminder> {
  List<String> reminderIds = [];
  List<String> times = [];
  List<String> messages = [];

  // Map to keep active timers by reminder id
  final Map<int, Timer> _reminderTimers = {};

  final _formKey = GlobalKey<FormState>();
  final _timeController = TextEditingController();
  final _messageController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    fetchReminders();
  }

  @override
  void dispose() {
    // Cancel all timers when widget disposed
    for (final t in _reminderTimers.values) {
      t.cancel();
    }
    _reminderTimers.clear();
    _timeController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> fetchReminders() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String urls = sh.getString('url') ?? 'http://10.0.2.2:8000';
    String lid = sh.getString('lid') ?? '1';
    print('Fetch URL: $urls/view_medicine_reminders/');

    try {
      var response = await http.post(
        Uri.parse('$urls/view_medicine_reminders/'),
        body: {'lid': lid},
      );
      print('Fetch Response: ${response.statusCode} ${response.body}');

      var jsondata = json.decode(response.body);
      if (jsondata['status'] == 'success') {
        var arr = jsondata['data'] as List;
        setState(() {
          reminderIds = arr.map<String>((item) => item['id'].toString()).toList();
          times = arr.map<String>((item) => item['time'].toString()).toList();
          messages = arr.map<String>((item) => item['message'].toString()).toList();
        });

        // Cancel existing timers
        for (final timer in _reminderTimers.values) {
          timer.cancel();
        }
        _reminderTimers.clear();

        // Schedule in-app reminders for fetched items
        for (int i = 0; i < reminderIds.length; i++) {
          final id = int.tryParse(reminderIds[i]) ?? DateTime.now().millisecondsSinceEpoch.remainder(100000);
          _scheduleReminder(id, messages[i], times[i]);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${jsondata['message']}')),
        );
      }
    } catch (e) {
      print("Fetch error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch reminders')),
      );
    }
  }

  Future<void> setReminder() async {
    if (_formKey.currentState!.validate() && _selectedTime != null) {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? 'http://10.0.2.2:8000';
      String lid = sh.getString('lid') ?? '1';

      final messageToSend = _messageController.text;

      String formattedTime =
          '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}:00';

      print('Set URL: $urls/set_medicine_reminder/');
      print('Formatted Time: $formattedTime');

      try {
        var response = await http.post(
          Uri.parse('$urls/set_medicine_reminder/'),
          body: {
            'lid': lid,
            'time': formattedTime,
            'message': messageToSend,
          },
        );
        print('Set Response: ${response.statusCode} ${response.body}');

        var jsondata = json.decode(response.body);
        if (jsondata['status'] == 'success') {
          int newId;
          try {
            newId = int.parse(jsondata['data']?['id']?.toString() ?? '');
          } catch (_) {
            newId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
          }

          _scheduleReminder(newId, messageToSend, formattedTime);

          _timeController.clear();
          _messageController.clear();
          _selectedTime = null;

          await fetchReminders();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reminder set successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${jsondata['message']}')),
          );
        }
      } catch (e) {
        print("Set reminder error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to set reminder')),
        );
      }
    }
  }

  /// Schedule a cancellable in-app reminder that repeats daily
  void _scheduleReminder(int id, String message, String timeStr) {
    // Cancel any existing timer immediately
    if (_reminderTimers.containsKey(id)) {
      _reminderTimers[id]!.cancel();
      _reminderTimers.remove(id);
    }

    final parts = timeStr.split(':');
    if (parts.length < 2) return;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    final now = DateTime.now();
    var reminderTime = DateTime(now.year, now.month, now.day, hour, minute);
    Duration delay = reminderTime.difference(now);
    if (delay.isNegative) {
      reminderTime = reminderTime.add(const Duration(days: 1));
      delay = reminderTime.difference(now);
    }

    // Schedule first reminder
    Timer timer = Timer(delay, () {
      if (!_reminderTimers.containsKey(id)) return;

      _showReminderDialog(message, timeStr);

      // Schedule daily repetition
      Timer dailyTimer = Timer.periodic(const Duration(days: 1), (t) {
        if (!_reminderTimers.containsKey(id)) {
          t.cancel();
          return;
        }
        _showReminderDialog(message, timeStr);
      });

      // Replace the initial one-time timer with the periodic timer
      _reminderTimers[id] = dailyTimer;
    });

    // Store initial timer immediately
    _reminderTimers[id] = timer;
  }

  void _showReminderDialog(String message, String timeStr) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("💊 Medicine Reminder"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("⏰ Time: $timeStr", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("💬 Message: $message"),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  Future<bool> deleteReminder(int reminderId) async {
    // Cancel timer immediately to prevent any popups
    if (_reminderTimers.containsKey(reminderId)) {
      _reminderTimers[reminderId]!.cancel();
      _reminderTimers.remove(reminderId);
      print('Cancelled timer for id=$reminderId');
    }

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? 'http://10.0.2.2:8000';
    print('Delete URL: $url/delete_reminder/, id=$reminderId');

    try {
      final response = await http.post(
        Uri.parse('$url/delete_reminder/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"reminder_id": reminderId}),
      );
      print('Delete response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok' || data['status'] == 'success') {
          await fetchReminders(); // Refresh the reminders list
          return true;
        } else {
          print('Server returned error on delete: ${data}');
        }
      } else {
        print('Unexpected status code deleting reminder: ${response.statusCode}');
      }
    } catch (e) {
      print('Delete exception: $e');
    }
    return false;
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage(title: '')));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Set Medicine Reminder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _timeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Time',
                        suffixIcon: IconButton(icon: Icon(Icons.access_time), onPressed: _selectTime),
                      ),
                      validator: (value) => value!.isEmpty ? 'Please select a time' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(labelText: 'Medicine Details'),
                      validator: (value) => value!.isEmpty ? 'Please enter medicine details' : null,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(onPressed: setReminder, child: Text('Set Reminder')),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text('Your Reminders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: reminderIds.length,
                  itemBuilder: (context, index) {
                    final idStr = reminderIds[index];
                    final displayTime = times[index];
                    final msg = messages[index];
                    final id = int.tryParse(idStr) ?? -1;
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(msg),
                        subtitle: Text('Time: $displayTime'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final ok = await showDialog<bool>(
                              context: context,
                              builder: (c) => AlertDialog(
                                title: Text('Delete Reminder'),
                                content: Text('Are you sure you want to delete this reminder?'),
                                actions: [
                                  TextButton(child: Text('Cancel'), onPressed: () => Navigator.pop(c, false)),
                                  TextButton(child: Text('Delete'), onPressed: () => Navigator.pop(c, true)),
                                ],
                              ),
                            );
                            if (ok != true) return;

                            final success = await deleteReminder(id);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reminder deleted')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete reminder')));
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}