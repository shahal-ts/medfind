// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'login.dart';
//
// void main() {
//   runApp(const SignUp());
// }
//
// class SignUp extends StatelessWidget {
//   const SignUp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SignUpPage(title: 'Sign Up'),
//     );
//   }
// }
//
// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController placeController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   String gender = "Male";
//
//   void sendData() async {
//     String name = nameController.text.trim();
//     String phone = phoneController.text.trim();
//     String email = emailController.text.trim();
//     String place = placeController.text.trim();
//     String age = ageController.text.trim();
//     String password = passwordController.text.trim();
//
//     if (name.isEmpty ||
//         phone.isEmpty ||
//         email.isEmpty ||
//         place.isEmpty ||
//         age.isEmpty ||
//         password.isEmpty) {
//       Fluttertoast.showToast(msg: "Please fill all fields");
//       return;
//     }
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//
//     try {
//       final response = await http.post(
//         Uri.parse('$url/register/'),
//         headers: {
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "username": name,   // MUST match Django
//           "phone": phone,
//           "email": email,
//           "address": place,   // MUST match Django
//           "age": age,
//           "gender": gender,
//           "password": password,
//         }),
//       );
//
//       print(response.body); // debug
//
//       var jsondata = jsonDecode(response.body);
//
//       if (jsondata['status'] == 'ok') {
//         Fluttertoast.showToast(msg: "Registration Successful");
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const LoginPage(title: "Login"),
//           ),
//         );
//       } else {
//         Fluttertoast.showToast(
//             msg: jsondata['message'] ?? "Registration Failed");
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Sign Up")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: "Full Name"),
//             ),
//             const SizedBox(height: 12),
//
//             TextFormField(
//               controller: phoneController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(labelText: "Phone"),
//             ),
//             const SizedBox(height: 12),
//
//             TextFormField(
//               controller: emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: const InputDecoration(labelText: "Email"),
//             ),
//             const SizedBox(height: 12),
//
//             TextFormField(
//               controller: placeController,
//               decoration: const InputDecoration(labelText: "Place"),
//             ),
//             const SizedBox(height: 12),
//
//             TextFormField(
//               controller: ageController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: "Age"),
//             ),
//             const SizedBox(height: 12),
//
//             Row(
//               children: [
//                 const Text("Gender: "),
//                 Radio<String>(
//                   value: "Male",
//                   groupValue: gender,
//                   onChanged: (v) => setState(() => gender = v!),
//                 ),
//                 const Text("Male"),
//                 Radio<String>(
//                   value: "Female",
//                   groupValue: gender,
//                   onChanged: (v) => setState(() => gender = v!),
//                 ),
//                 const Text("Female"),
//               ],
//             ),
//
//             TextFormField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: "Password"),
//             ),
//
//             const SizedBox(height: 25),
//
//             ElevatedButton(
//               onPressed: sendData,
//               child: const Text("Sign Up"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

void main() {
  runApp(const SignUp());
}

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA5C422),
          primary: const Color(0xFFA5C422),
        ),
        useMaterial3: true,
      ),
      home: const SignUpPage(title: 'Sign Up'),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.title});
  final String title;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String gender = "Male";
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    placeController.dispose();
    ageController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void sendData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String place = placeController.text.trim();
    String age = ageController.text.trim();
    String password = passwordController.text.trim();

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    try {
      final response = await http.post(
        Uri.parse('$url/register/'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": name,
          "phone": phone,
          "email": email,
          "address": place,
          "age": age,
          "gender": gender,
          "password": password,
        }),
      );

      print(response.body);

      var jsondata = jsonDecode(response.body);

      if (jsondata['status'] == 'ok') {
        Fluttertoast.showToast(
          msg: "Registration Successful",
          backgroundColor: const Color(0xFFA5C422),
          textColor: Colors.white,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(title: "Login"),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
          msg: jsondata['message'] ?? "Registration Failed",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Network Error. Check connection.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  InputDecoration _buildInputDecoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFA5C422), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Icon Section
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA5C422),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFA5C422).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_add_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fill in your details to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Sign Up Form Card
                  Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Full Name
                            TextFormField(
                              controller: nameController,
                              decoration: _buildInputDecoration(
                                'Full Name',
                                'Enter your full name',
                                Icons.person_outline,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Phone
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: _buildInputDecoration(
                                'Phone Number',
                                'Enter your phone number',
                                Icons.phone_outlined,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                if (value.length < 10) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Email
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _buildInputDecoration(
                                'Email Address',
                                'Enter your email',
                                Icons.email_outlined,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Place and Age Row
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: placeController,
                                    decoration: _buildInputDecoration(
                                      'Place',
                                      'City',
                                      Icons.location_on_outlined,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                SizedBox(
                                  width: 120,
                                  child: TextFormField(
                                    controller: ageController,
                                    keyboardType: TextInputType.number,
                                    decoration: _buildInputDecoration(
                                      'Age',
                                      '25',
                                      Icons.cake_outlined,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Gender Selection
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Gender',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () =>
                                              setState(() => gender = "Male"),
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            decoration: BoxDecoration(
                                              color: gender == "Male"
                                                  ? const Color(0xFFA5C422)
                                                  : Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              border: Border.all(
                                                color: gender == "Male"
                                                    ? const Color(0xFFA5C422)
                                                    : const Color(0xFFE0E0E0),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.male,
                                                  color: gender == "Male"
                                                      ? Colors.white
                                                      : Colors.grey[600],
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Male',
                                                  style: TextStyle(
                                                    color: gender == "Male"
                                                        ? Colors.white
                                                        : Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () =>
                                              setState(() => gender = "Female"),
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            decoration: BoxDecoration(
                                              color: gender == "Female"
                                                  ? const Color(0xFFA5C422)
                                                  : Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              border: Border.all(
                                                color: gender == "Female"
                                                    ? const Color(0xFFA5C422)
                                                    : const Color(0xFFE0E0E0),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.female,
                                                  color: gender == "Female"
                                                      ? Colors.white
                                                      : Colors.grey[600],
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Female',
                                                  style: TextStyle(
                                                    color: gender == "Female"
                                                        ? Colors.white
                                                        : Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Password
                            TextFormField(
                              controller: passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Create a password',
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.grey[600],
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE0E0E0), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFA5C422), width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),

                            // Sign Up Button
                            ElevatedButton(
                              onPressed: _isLoading ? null : sendData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA5C422),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                disabledBackgroundColor:
                                const Color(0xFFA5C422).withOpacity(0.5),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                                  : const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const LoginPage(title: "Login"),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xFFA5C422),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}