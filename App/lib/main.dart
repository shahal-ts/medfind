// import 'package:flutter/material.dart';
// import 'package:medifind/login.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'notification_service.dart'; // 🔔 ADD THIS
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // 🔔 Initialize notifications
//   await NotificationService.init();
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyAppPage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyAppPage extends StatefulWidget {
//   const MyAppPage({super.key, required this.title});
//   final String title;
//
//   @override
//   State<MyAppPage> createState() => _MyAppPageState();
// }
//
// class _MyAppPageState extends State<MyAppPage> {
//   TextEditingController ipc = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: TextField(
//                 keyboardType: TextInputType.number,
//                 controller: ipc,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'IP',
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 send_data();
//               },
//               child: const Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void send_data() async {
//     String ipdata = ipc.text;
//     SharedPreferences sh = await SharedPreferences.getInstance();
//
//     sh.setString("ip", ipdata);
//     sh.setString("url", "http://$ipdata:8000");
//     sh.setString("Image_url", "http://$ipdata:8000");
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const LoginPage(title: 'Login'),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:medifind/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediFind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA5C422),
          primary: const Color(0xFFA5C422),
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
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
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA5C422),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const MyAppPage(title: 'Server Configuration'),
    );
  }
}

class MyAppPage extends StatefulWidget {
  const MyAppPage({super.key, required this.title});
  final String title;

  @override
  State<MyAppPage> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  TextEditingController ipc = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    ipc.dispose();
    super.dispose();
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
                children: <Widget>[
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
                      Icons.dns_outlined,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Server Setup',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your server IP address to continue',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Card with Form
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
                            // IP Input Field
                            TextFormField(
                              controller: ipc,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Server IP Address',
                                hintText: '192.168.1.1',
                                prefixIcon: Icon(
                                  Icons.router,
                                  color: Colors.grey[600],
                                ),
                                labelStyle: TextStyle(color: Colors.grey[700]),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an IP address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),

                            // Submit Button
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  send_data();
                                }
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Help Text
                  TextButton.icon(
                    onPressed: () {
                      // Add help dialog or navigation
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Need Help?'),
                          content: const Text(
                            'The server IP address should be provided by your system administrator. '
                                'It typically looks like 192.168.1.1 or similar format.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Got it'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.help_outline, color: Colors.grey[600]),
                    label: Text(
                      'Need help finding your IP?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void send_data() async {
    String ipdata = ipc.text;
    SharedPreferences sh = await SharedPreferences.getInstance();

    sh.setString("ip", ipdata);
    sh.setString("url", "http://$ipdata:8000");
    sh.setString("Image_url", "http://$ipdata:8000");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(title: 'Login'),
      ),
    );
  }
}