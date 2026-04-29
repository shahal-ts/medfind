// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class CallPage extends StatefulWidget {
//   const CallPage({super.key});
//
//   @override
//   State<CallPage> createState() => _CallPageState();
// }
//
// class _CallPageState extends State<CallPage> {
//   List<String> phoneNumbers = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchEmergencyNumbers();
//   }
//
//   Future<void> fetchEmergencyNumbers() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var lid = prefs.getString('lid');
//     var baseUrl = prefs.getString("url");
//     var url = Uri.parse("$baseUrl/get_call_numbers/");
//
//     try {
//       var response = await http.post(url, body: {'lid': lid ?? ''});
//       var data = jsonDecode(response.body);
//
//       if (data['status'] == 'ok') {
//         setState(() {
//           // Wrap the number in a list to match ListView structure
//           phoneNumbers = [data['number']];
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("No emergency contacts found")),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }
//
//   Future<void> makeCall(String number) async {
//     bool? res = await FlutterPhoneDirectCaller.callNumber(number);
//     if (res == false) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Unable to make the call")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Emergency Call"),
//         backgroundColor: Colors.redAccent,
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : phoneNumbers.isEmpty
//           ? const Center(child: Text("No emergency numbers available"))
//           : ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: phoneNumbers.length,
//         itemBuilder: (context, index) {
//           final number = phoneNumbers[index];
//           return Card(
//             elevation: 3,
//             margin: const EdgeInsets.symmetric(vertical: 10),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: ListTile(
//               contentPadding: const EdgeInsets.all(15),
//               leading: const Icon(
//                 Icons.phone,
//                 color: Colors.redAccent,
//                 size: 30,
//               ),
//               title: Text(
//                 number,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               trailing: ElevatedButton(
//                 onPressed: () => makeCall(number),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent,
//                 ),
//                 child: const Text(
//                   "Call",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  List<String> phoneNumbers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmergencyNumbers();
  }

  // 🔹 Fetch emergency number from backend
  Future<void> fetchEmergencyNumbers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lid = prefs.getString('lid');
    var baseUrl = prefs.getString("url");

    try {
      var response = await http.post(
        Uri.parse("$baseUrl/get_call_numbers/"),
        body: {'lid': lid ?? ''},
      );
      var data = jsonDecode(response.body);

      if (data['status'] == 'ok') {
        setState(() {
          phoneNumbers = [data['number']];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        Fluttertoast.showToast(msg: "No emergency number found");
      }
    } catch (e) {
      setState(() => isLoading = false);
      Fluttertoast.showToast(msg: "Error fetching number: $e");
    }
  }

  // 🔹 Get current location using `location` plugin
  Future<LocationData?> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return null;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return null;
    }

    return await location.getLocation();
  }

  // 🔹 Send SMS with Google Maps link
  Future<void> sendEmergencySMS(String phone) async {
    var loc = await getCurrentLocation();
    if (loc == null) {
      Fluttertoast.showToast(msg: "Location not available");
      return;
    }

    String message =
        "🚨 EMERGENCY ALERT 🚨\nI need help immediately!\n\n"
        "📍 My Location: https://www.google.com/maps?q=${loc.latitude},${loc.longitude}";

    final Uri smsUri =
    Uri.parse("sms:$phone?body=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      Fluttertoast.showToast(msg: "Cannot open SMS app");
    }
  }

  // 🔹 Make phone call
  Future<void> makeCall(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  // 🔹 Emergency action: SMS + Call
  Future<void> emergencyAction(String number) async {
    await sendEmergencySMS(number);
    await makeCall(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Call"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : phoneNumbers.isEmpty
          ? const Center(child: Text("No emergency number found"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: phoneNumbers.length,
        itemBuilder: (context, index) {
          final number = phoneNumbers[index];
          return Card(
            elevation: 4,
            child: ListTile(
              leading: const Icon(
                Icons.phone_in_talk,
                color: Colors.red,
                size: 30,
              ),
              title: Text(
                number,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () => emergencyAction(number),
                child: const Text(
                  "CALL",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
