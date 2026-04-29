import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SetEmergencyNumberPage extends StatefulWidget {
  const SetEmergencyNumberPage({super.key});

  @override
  State<SetEmergencyNumberPage> createState() => _SetEmergencyNumberPageState();
}

class _SetEmergencyNumberPageState extends State<SetEmergencyNumberPage> {
  final TextEditingController _numberController = TextEditingController();

  Future<void> saveNumber() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String baseUrl = sh.getString("url").toString();
    String lid = sh.getString("lid").toString();

    var response = await http.post(
      Uri.parse("$baseUrl/set_emergency_number/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "lid": lid,
        "number": _numberController.text,
      }),
    );

    var data = jsonDecode(response.body);
    if (data["status"] == "ok") {
      Fluttertoast.showToast(msg: "Emergency number saved successfully!");
    } else {
      Fluttertoast.showToast(msg: data["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Emergency Number")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _numberController,
              decoration: const InputDecoration(
                labelText: "Caretaker Phone Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveNumber,
              child: const Text("Save Number"),
            ),
          ],
        ),
      ),
    );
  }
}
