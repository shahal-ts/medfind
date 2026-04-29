// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'editprofile.dart';
//
// class MyProfilePage extends StatefulWidget {
//   const MyProfilePage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<MyProfilePage> createState() => _MyProfilePageState();
// }
//
// class _MyProfilePageState extends State<MyProfilePage> {
//   String name = "", phone = "", email = "", place = "", age = "", gender = "";
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProfile();
//   }
//
//   void fetchProfile() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url') ?? "http://127.0.0.1:8000";
//     String lid = sh.getString('lid') ?? "";
//
//     try {
//       final response = await http.post(Uri.parse('$url/viewprofile/'), body: {'lid': lid});
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data['status'] == 'ok') {
//           setState(() {
//             name = data['name'];
//             phone = data['phone'];
//             email = data['email'];
//             place = data['place'];
//             age = data['age'].toString();
//             gender = data['gender'];
//           });
//         } else {
//           Fluttertoast.showToast(msg: "Profile not found");
//         }
//       } else {
//         Fluttertoast.showToast(msg: "Network error");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text(widget.title)),
//         body: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text("Name: $name"),
//             Text("Phone: $phone"),
//             Text("Email: $email"),
//             Text("Place: $place"),
//             Text("Age: $age"),
//             Text("Gender: $gender"),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const MyEditProfile(title: "Edit Profile")));
//               },
//               child: const Text("Edit Profile"),
//             )
//           ]),
//         ));
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'editprofile.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key, required this.title});
  final String title;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String name = "", phone = "", email = "", place = "", age = "", gender = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  void fetchProfile() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "http://127.0.0.1:8000";
    String lid = sh.getString('lid') ?? "";

    try {
      final response = await http.post(Uri.parse('$url/viewprofile/'), body: {'lid': lid});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            name = data['name'] ?? "Not set";
            phone = data['phone'] ?? "Not set";
            email = data['email'] ?? "Not set";
            place = data['place'] ?? "Not set";
            age = data['age']?.toString() ?? "Not set";
            gender = data['gender'] ?? "Not set";
            isLoading = false;
          });
        } else {
          Fluttertoast.showToast(msg: "Profile not found");
          setState(() => isLoading = false);
        }
      } else {
        Fluttertoast.showToast(msg: "Network error • ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString().split('\n')[0]}");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFA5C422);
    final textDark = Colors.black87;
    final textLight = Colors.grey[800]!;
    final dividerColor = Colors.grey[300]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.black87,
        elevation: 2,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA5C422)),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header / Avatar area
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: primaryColor.withOpacity(0.15),
                    child: Icon(
                      Icons.person_rounded,
                      size: 60,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name.isNotEmpty && name != "Not set" ? name : "User Profile",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email != "Not set" ? email : "No email provided",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Profile Card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              shadowColor: primaryColor.withOpacity(0.15),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      icon: Icons.phone_android_rounded,
                      label: "Phone",
                      value: phone,
                      color: primaryColor,
                    ),
                    const Divider(height: 32, color: Colors.grey),
                    _buildInfoRow(
                      icon: Icons.email_rounded,
                      label: "Email",
                      value: email,
                      color: primaryColor,
                    ),
                    const Divider(height: 32, color: Colors.grey),
                    _buildInfoRow(
                      icon: Icons.location_on_rounded,
                      label: "Place",
                      value: place,
                      color: primaryColor,
                    ),
                    const Divider(height: 32, color: Colors.grey),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoRow(
                            icon: Icons.calendar_today_rounded,
                            label: "Age",
                            value: age,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildInfoRow(
                            icon: Icons.wc_rounded,
                            label: "Gender",
                            value: gender,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyEditProfile(title: "Edit Profile"),
                    ),
                  ).then((_) {
                    // Refresh profile when returning from edit
                    fetchProfile();
                  });
                },
                icon: const Icon(Icons.edit, size: 20),
                label: const Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: color.withOpacity(0.9)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}