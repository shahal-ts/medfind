import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PharmacyMedicinesPage extends StatefulWidget {
  final int pharmacyId;
  final String pharmacyName;

  const PharmacyMedicinesPage({
    super.key,
    required this.pharmacyId,
    required this.pharmacyName,
  });

  @override
  State<PharmacyMedicinesPage> createState() => _PharmacyMedicinesPageState();
}

class _PharmacyMedicinesPageState extends State<PharmacyMedicinesPage> {
  List medicines = [];
  bool loading = true;
  TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString("url").toString();

    final apiUrl = Uri.parse("$url/view_medicines/${widget.pharmacyId}/");

    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'ok') {
          setState(() {
            medicines = jsondata['medicines'];
            loading = false;
          });
        } else {
          setState(() => loading = false);
        }
      }
    } catch (e) {
      print("Error: $e");
      setState(() => loading = false);
    }
  }

  void addToCartDialog(int medId) {
    _quantityController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Quantity'),
        content: TextField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Quantity',
            hintText: 'Enter quantity',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _quantityController.clear();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await addToCart(medId, _quantityController.text);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> addToCart(int medId, String quantity) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString("url").toString();
    String lid = sh.getString("lid").toString();

    final apiUrl = Uri.parse("$url/add_to_cart/");

    try {
      final response = await http.post(apiUrl, body: {
        'lid': lid,
        'medicine_id': medId.toString(),
        'quantity': quantity,
      });

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'ok') {
          Fluttertoast.showToast(msg: "Added to cart");
        } else {
          Fluttertoast.showToast(msg: "Failed to add to cart");
        }
      } else {
        Fluttertoast.showToast(msg: "Network Error");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pharmacyName),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : medicines.isEmpty
          ? const Center(child: Text("No medicines found"))
          : ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          var med = medicines[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(med['name']),
              subtitle: Text(
                  "${med['description'] ?? ''}\nPrice: ₹${med['price']} | Stock: ${med['stock']}"),
              isThreeLine: true,
              trailing: ElevatedButton(
                onPressed: () {
                  addToCartDialog(med['id']);
                },
                child: const Text("Add to Cart"),
              ),
            ),
          );
        },
      ),
    );
  }
}
