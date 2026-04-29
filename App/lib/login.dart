// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:medifind/sighnup.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'home.dart';
// // import 'signup.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(const Login());
// }
//
// class Login extends StatelessWidget {
//   const Login({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginPage(title: 'Login'),
//     );
//   }
// }
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   void sendData() async {
//     String username = usernameController.text.trim();
//     String password = passwordController.text.trim();
//
//     if (username.isEmpty || password.isEmpty) {
//       Fluttertoast.showToast(msg: 'Please fill all fields');
//       return;
//     }
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url') ?? '';
//     if (url.isEmpty) {
//       Fluttertoast.showToast(msg: 'Please set your server IP first');
//       return;
//     }
//
//     final loginUrl = Uri.parse('$url/user_login/');
//
//     try {
//       final response = await http.post(
//         loginUrl,
//         headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//         body: {
//           'username': username,
//           'password': password,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         var jsondata = jsonDecode(response.body);
//         String status = jsondata['status'];
//
//         if (status == 'ok') {
//           String lid = jsondata['lid'].toString();
//           sh.setString('lid', lid);
//
//           Fluttertoast.showToast(msg: 'Login Successful');
//
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const HomeScreen(title: 'Home')),
//           );
//         } else {
//           Fluttertoast.showToast(msg: 'Invalid credentials or user not registered');
//         }
//       } else {
//         Fluttertoast.showToast(
//             msg:
//             'Server Error ${response.statusCode}. Check your Django backend is running.');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//           msg:
//           'Network Error: $e. Make sure your IP and port are correct and server is running.');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               controller: usernameController,
//               decoration: InputDecoration(
//                 border:
//                 OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
//                 label: const Text('Username'),
//                 hintText: 'Enter Username',
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextFormField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 border:
//                 OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
//                 label: const Text('Password'),
//                 hintText: 'Enter Password',
//               ),
//             ),
//             const SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(onPressed: sendData, child: const Text('Login')),
//                 const SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                             const SignUpPage(title: 'Sign Up')));
//                   },
//                   child: const Text('Sign Up'),
//                 ),
//               ],
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
import 'package:medifind/sighnup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({super.key});

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
      home: const LoginPage(title: 'Login'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
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

    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url') ?? '';
    if (url.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: 'Please set your server IP first',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final loginUrl = Uri.parse('$url/user_login/');

    try {
      final response = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        String status = jsondata['status'];

        if (status == 'ok') {
          String lid = jsondata['lid'].toString();
          sh.setString('lid', lid);

          Fluttertoast.showToast(
            msg: 'Login Successful',
            backgroundColor: const Color(0xFFA5C422),
            textColor: Colors.white,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const HomeScreen(title: 'Home'         )),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(
            msg: 'Invalid credentials or user not registered',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
          msg: 'Server Error ${response.statusCode}',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: 'Network Error. Check server connection.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA5C422),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFA5C422).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_hospital_outlined,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue to MediFind',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Login Form Card
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
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
                            // Username Field
                            TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                hintText: 'Enter your username',
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Colors.grey[600],
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
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Password Field
                            TextFormField(
                              controller: passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
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
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),

                            // Login Button
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
                                'Login',
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

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const SignUpPage(title: 'Sign Up'),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: const Text(
                          'Sign Up',
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