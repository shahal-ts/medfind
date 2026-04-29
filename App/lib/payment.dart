import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medifind/home.dart';
import 'package:medifind/viewpayment.dart';
// import 'package:gym/myorders.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BuyAllCart extends StatefulWidget {
  const BuyAllCart({super.key, required this.totalAmount});
  final String totalAmount;


  @override
  State<BuyAllCart> createState() => _BuyAllCartState();
}

class _BuyAllCartState extends State<BuyAllCart> {
  late Razorpay _razorpay;
  String totalAmount = "0";

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _fetchTotalAmount();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _fetchTotalAmount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? baseUrl = prefs.getString('url');
      String? lid = prefs.getString('lid');

      if (baseUrl == null || lid == null) return;

      final response = await http.post(
        Uri.parse('$baseUrl/sumofcart/'),
        body: {'lid': lid},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == 'ok') {
          setState(() {
            totalAmount = jsonData['total_sum'].toString();
          });
        } else {
          Fluttertoast.showToast(msg: "Cart is empty");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Network error while fetching total: ${response.statusCode}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching total: $e");
    }
  }

  void _openCheckout() {
    if (totalAmount == "0") {
      Fluttertoast.showToast(msg: "Cart is empty");
      return;
    }

    double amountInPaise = double.parse(totalAmount) * 100;

    var options = {
      'key': 'rzp_test_HKCAwYtLt0rwQe',
      'amount': amountInPaise,
      'name': 'Your Shop Name',
      'description': 'Payment for Cart Items',
      'prefill': {'contact': '9747360170', 'email': 'user@example.com'},
      'external': {'wallets': ['paytm']}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error opening payment: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? baseUrl = prefs.getString('url');
      String? lid = prefs.getString('lid');

      if (baseUrl == null || lid == null) return;

      final backendResponse = await http.post(
        Uri.parse('$baseUrl/payment_view/'),
        body: {
          'lid': lid,
          'total_sum': totalAmount,
          'payment_id': response.paymentId,
        },
      );

      if (backendResponse.statusCode == 200) {
        var result = json.decode(backendResponse.body);
        if (result['status'] == 'ok') {
          Fluttertoast.showToast(msg: "Payment successful!");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewPayments()));
        } else {
          Fluttertoast.showToast(msg: "Payment failed on server: ${result['message']}");
        }
      } else {
        Fluttertoast.showToast(msg: "Network error during payment verification");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error during payment: $e");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment failed: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "External Wallet Selected: ${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buy All Cart Items"),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Total Amount: ₹$totalAmount",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openCheckout,
              child: const Text("Pay Now"),
            ),
          ],
        ),
      ),
    );
  }
}
