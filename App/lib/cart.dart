import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medifind/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'buy_all_cart.dart'; // Import your BuyAllCart payment page

class CartPage extends StatefulWidget {
  const CartPage({super.key});


  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List cartItems = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    setState(() => loading = true);
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString("url") ?? "";
    String lid = sh.getString("lid") ?? "";

    final apiUrl = Uri.parse("$url/view_cart/$lid/");

    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'ok') {
          setState(() {
            cartItems = jsondata['cart_items'];
            loading = false;
          });
        } else {
          setState(() => loading = false);
        }
      }
    } catch (e) {
      print("Error fetching cart: $e");
      setState(() => loading = false);
    }
  }

  void updateQuantity(int cartId, int newQuantity) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString("url") ?? "";

    final apiUrl = Uri.parse("$url/update_cart_quantity/");

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cart_id': cartId,
          'quantity': newQuantity,
        }),
      );

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'ok') {
          Fluttertoast.showToast(msg: "Quantity updated");
          fetchCart();
        } else {
          Fluttertoast.showToast(msg: jsondata['message']);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void removeFromCart(int cartId) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString("url") ?? "";

    final apiUrl = Uri.parse("$url/remove_from_cart/");

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'cart_id': cartId}),
      );

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'ok') {
          Fluttertoast.showToast(msg: "Item removed");
          fetchCart();
        } else {
          Fluttertoast.showToast(msg: jsondata['message']);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var item in cartItems) {
      total += (double.parse(item['price'].toString()) *
          int.parse(item['quantity'].toString()));
    }
    return total;
  }

  void checkout() {
    double total = getTotalPrice();

    if (total == 0) {
      Fluttertoast.showToast(msg: "Cart is empty");
      return;
    }

    // Navigate to BuyAllCart payment page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuyAllCart(
          totalAmount: total.toString(),

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                var item = cartItems[index];
                TextEditingController qtyController =
                TextEditingController(
                    text: item['quantity'].toString());

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(item['medicine_name']),
                    subtitle: Text(
                        "Price: ₹${item['price']} | Stock: ${item['stock']}"),
                    trailing: SizedBox(
                      width: 150,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: qtyController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Qty",
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () {
                              int newQty = int.tryParse(
                                  qtyController.text) ??
                                  1;
                              updateQuantity(item['id'], newQty);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              removeFromCart(item['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ₹${getTotalPrice().toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: checkout,
                  child: const Text("Checkout"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
