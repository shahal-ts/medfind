import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UploadPrescriptionPage extends StatefulWidget {
  const UploadPrescriptionPage({super.key});

  @override
  State<UploadPrescriptionPage> createState() => _UploadPrescriptionPageState();
}

class _UploadPrescriptionPageState extends State<UploadPrescriptionPage> {
  File? _image;
  final picker = ImagePicker();
  String extractedText = "";

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future uploadPrescription() async {
    if (_image == null) {
      Fluttertoast.showToast(msg: "Please select an image first");
      return;
    }

    SharedPreferences sh = await SharedPreferences.getInstance();
    String baseUrl = sh.getString("url").toString();
    String userId = sh.getString("lid") ?? "";

    var request = http.MultipartRequest("POST", Uri.parse("$baseUrl/upload_prescription/"));
    request.fields['lid'] = userId; // ✅ matches Django key
    request.files.add(await http.MultipartFile.fromPath("prescription", _image!.path)); // ✅ matches Django key

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (data["status"] == "ok") {
        setState(() {
          extractedText = data["extracted_text"];
        });
        Fluttertoast.showToast(msg: "Prescription uploaded successfully!");
      } else {
        Fluttertoast.showToast(msg: data["message"] ?? "Upload failed");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Prescription")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _image == null
                ? const Text("No image selected")
                : Image.file(_image!, height: 200),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Select Image"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadPrescription,
              child: const Text("Upload & Scan"),
            ),
            const SizedBox(height: 20),
            Text("Extracted Text: $extractedText"),
          ],
        ),
      ),
    );
  }
}
