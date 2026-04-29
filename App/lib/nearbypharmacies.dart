// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:medifind/pharmacymedicinespage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
// // import 'pharmacy_medicines.dart';
//
// class PharmaciesPage extends StatefulWidget {
//   const PharmaciesPage({super.key});
//
//   @override
//   State<PharmaciesPage> createState() => _PharmaciesPageState();
// }
//
// class _PharmaciesPageState extends State<PharmaciesPage> {
//   List pharmacies = [];
//   bool loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchPharmacies();
//   }
//
//   void fetchPharmacies() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString("url").toString();
//     final apiUrl = Uri.parse("$url/all_pharmacies/"); // backend endpoint to get all pharmacies
//
//     try {
//       final response = await http.get(apiUrl);
//
//       if (response.statusCode == 200) {
//         var jsondata = jsonDecode(response.body);
//         if (jsondata['status'] == 'ok') {
//           setState(() {
//             pharmacies = jsondata['pharmacies'];
//             loading = false;
//           });
//         }
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//   void navigateToMap(double lat, double lng) async {
//     String url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url));
//     } else {
//       print("Cannot launch maps");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Pharmacies"),
//         centerTitle: true,
//       ),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//           itemCount: pharmacies.length,
//           itemBuilder: (context, index) {
//             var pharmacy = pharmacies[index];
//             return Card(
//               margin: const EdgeInsets.all(8),
//               child: ListTile(
//                 title: Text(pharmacy['pharmacy_name']),
//                 subtitle: Text(pharmacy['place']),
//                 trailing: Wrap(
//                   spacing: 10,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.map),
//                       onPressed: () {
//                         navigateToMap(pharmacy['latitude'], pharmacy['longitude']);
//                       },
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.arrow_forward),
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => PharmacyMedicinesPage(
//                                   pharmacyId: pharmacy['id'],
//                                   pharmacyName: pharmacy['pharmacy_name'],
//                                 )));
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medifind/pharmacymedicinespage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';

class PharmaciesPage extends StatefulWidget {
  const PharmaciesPage({super.key});

  @override
  State<PharmaciesPage> createState() => _PharmaciesPageState();
}

class _PharmaciesPageState extends State<PharmaciesPage> {
  List pharmacies = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchNearbyPharmacies();
  }

  // 📍 Get user location
  Future<LocationData?> getUserLocation() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return null;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return null;
    }

    return await location.getLocation();
  }

  // 🔹 Fetch nearby pharmacies
  void fetchNearbyPharmacies() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString("url").toString();

    LocationData? loc = await getUserLocation();
    if (loc == null) {
      setState(() => loading = false);
      return;
    }

    final apiUrl = Uri.parse("$url/nearby_pharmacies/");

    try {
      final response = await http.post(
        apiUrl,
        body: {
          'latitude': loc.latitude.toString(),
          'longitude': loc.longitude.toString(),
        },
      );

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'ok') {
          setState(() {
            pharmacies = jsondata['pharmacies'];
            loading = false;
          });
        }
      }
    } catch (e) {
      print("Error: $e");
      setState(() => loading = false);
    }
  }

  // 🗺️ Open Google Maps
  void navigateToMap(double lat, double lng) async {
    String url = "https://www.google.com/maps?q=$lat,$lng";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Pharmacies"),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : pharmacies.isEmpty
          ? const Center(child: Text("No nearby pharmacies found"))
          : ListView.builder(
        itemCount: pharmacies.length,
        itemBuilder: (context, index) {
          var pharmacy = pharmacies[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(pharmacy['pharmacy_name']),
              subtitle: Text(
                "${pharmacy['place']} • ${pharmacy['distance'].toStringAsFixed(2)} km",
              ),
              trailing: Wrap(
                spacing: 10,
                children: [
                  IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () {
                      navigateToMap(
                        pharmacy['latitude'],
                        pharmacy['longitude'],
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PharmacyMedicinesPage(
                                pharmacyId: pharmacy['id'],
                                pharmacyName:
                                pharmacy['pharmacy_name'],
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
