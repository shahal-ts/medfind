import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'viewprofile.dart';

class MyEditProfile extends StatefulWidget {
  const MyEditProfile({super.key, required this.title});
  final String title;

  @override
  State<MyEditProfile> createState() => _MyEditProfileState();
}

class _MyEditProfileState extends State<MyEditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();

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
          nameController.text = data['name'];
          phoneController.text = data['phone'];
          emailController.text = data['email'];
          placeController.text = data['place'];
          ageController.text = data['age'].toString();
          genderController.text = data['gender'];
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void updateProfile() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? "http://127.0.0.1:8000";
    String lid = sh.getString('lid') ?? "";

    try {
      final response = await http.post(Uri.parse('$url/editprofile/'), body: {
        'lid': lid,
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'place': placeController.text,
        'age': ageController.text,
        'gender': genderController.text,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(msg: "Profile updated");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyProfilePage(title: "Profile")));
        } else {
          Fluttertoast.showToast(msg: "Failed to update");
        }
      } else {
        Fluttertoast.showToast(msg: "Network error");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: placeController, decoration: const InputDecoration(labelText: "Place")),
              TextField(controller: ageController, decoration: const InputDecoration(labelText: "Age")),
              TextField(controller: genderController, decoration: const InputDecoration(labelText: "Gender")),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: updateProfile, child: const Text("Save Changes"))
            ],
          ),
        ),
      ),
    );
  }
}
