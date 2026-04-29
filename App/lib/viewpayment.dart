import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class ViewPayments extends StatefulWidget {
  const ViewPayments({super.key});

  @override
  State<ViewPayments> createState() => _ViewPaymentsState();
}

class _ViewPaymentsState extends State<ViewPayments> {
  List payments = [];

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? baseUrl = prefs.getString('url');
      String? lid = prefs.getString('lid');

      if (baseUrl == null || lid == null) {
        Fluttertoast.showToast(msg: "Missing user info");
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/view_payments/'),
        body: {'lid': lid},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == 'ok') {
          setState(() {
            payments = jsonData['payments'];
          });
        } else {
          Fluttertoast.showToast(msg: jsonData['message'] ?? "No payments found");
        }
      } else {
        Fluttertoast.showToast(msg: "Network error: ${response.statusCode}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching payments: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.pink,
      ),
      body: payments.isEmpty
          ? const Center(child: Text("No orders found"))
          : ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          var item = payments[index];
          String status = item['payment_status'] ?? 'Pending';

          return Card(
            margin: const EdgeInsets.all(8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.shopping_bag, color: Colors.pink),
              title: Text(
                "Order ID: ${item['order_id']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text("Total: ₹${item['total_amount']}"),
                  const SizedBox(height: 3),
                  Text(
                    "Status: $status",
                    style: TextStyle(
                      color: status == "Dispatched"
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text("Date: ${item['date']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
