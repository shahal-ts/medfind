// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:sms_sender_background/sms_sender_background.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:location/location.dart';
//
// class SmsPage extends StatefulWidget {
//   const SmsPage({super.key});
//
//   @override
//   State<SmsPage> createState() => _SmsPageState();
// }
//
// class _SmsPageState extends State<SmsPage> {
//   String? phoneNumber;
//   bool isLoading = true;
//   final Location location = Location();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchEmergencyNumber();
//     SmsSenderBackground.initialize();
//   }
//
//   Future<void> fetchEmergencyNumber() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var lid = prefs.getString('lid');
//     var url = Uri.parse("http://192.168.1.74:8000/api/get_emergency_number/");
//
//     var response = await http.post(url, body: {'lid': lid ?? ''});
//     var data = jsonDecode(response.body);
//
//     if (data['status'] == 'ok') {
//       setState(() {
//         phoneNumber = data['emergency_number'];
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         phoneNumber = null;
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("No emergency number found")),
//       );
//     }
//   }
//
//   Future<void> sendLocationSMS() async {
//     if (phoneNumber == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("No emergency number available")),
//       );
//       return;
//     }
//
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Location services are disabled")),
//         );
//         return;
//       }
//     }
//
//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Location permission denied")),
//         );
//         return;
//       }
//     }
//
//     LocationData currentLocation = await location.getLocation();
//     String message =
//         "EMERGENCY ALERT! Please help me. My location: https://www.google.com/maps?q=${currentLocation.latitude},${currentLocation.longitude}";
//
//     try {
//       await SmsSenderBackground.send(
//         phoneNumber!,
//         message,
//         simSlot: 1,
//       );
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Location SMS sent successfully")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to send SMS: $e")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Emergency SMS"),
//         backgroundColor: Colors.blueAccent,
//         centerTitle: true,
//       ),
//       body: Center(
//         child: isLoading
//             ? const CircularProgressIndicator()
//             : Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.sms, color: Colors.blueAccent, size: 80),
//             const SizedBox(height: 20),
//             Text(
//               phoneNumber ?? "No number found",
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 40),
//             ElevatedButton.icon(
//               onPressed: sendLocationSMS,
//               icon: const Icon(Icons.sms, color: Colors.white),
//               label: const Text("Send Location SMS"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blueAccent,
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 30, vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 textStyle: const TextStyle(
//                     fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
