import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ViewRemindersPage extends StatefulWidget {
  const ViewRemindersPage({super.key});

  @override
  State<ViewRemindersPage> createState() => _ViewRemindersPageState();
}

class _ViewRemindersPageState extends State<ViewRemindersPage> {
  List reminders = [];
  bool loading = true;
  String baseUrl = '';

  @override
  void initState() {
    super.initState();
    loadReminders();
  }

  Future<void> loadReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lid = prefs.getString('lid');
    baseUrl = prefs.getString('url') ?? '';

    var url = Uri.parse("$baseUrl/view_reminders/$lid/");
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    if (data['status'] == 'ok') {
      setState(() {
        reminders = data['reminders'];
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? "Failed to load reminders")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Reminders")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : reminders.isEmpty
          ? const Center(child: Text("No reminders found"))
          : ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          var r = reminders[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text("${r['medicine_name']} (${r['dosage']})"),
              subtitle: Text(
                  "Qty: ${r['quantity']}\nTime: ${r['time_to_take']}\nStart: ${r['start_date']}  End: ${r['end_date']}\nStatus: ${r['status']}"),
            ),
          );
        },
      ),
    );
  }
}
