// import 'package:flutter/material.dart';
// import 'package:medifind/add_reminder.dart';
// import 'package:medifind/cart.dart';
// import 'package:medifind/nearbypharmacies.dart';
// import 'package:medifind/prescriptionanalysis.dart';
// import 'package:medifind/set_emergency_number.dart';
// import 'package:medifind/view_reminder.dart';
// import 'package:medifind/viewprofile.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'call.dart';
// import 'login.dart';
//
// void main() {
//   runApp(const HomePage(title: 'Home'));
// }
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(title: title),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   String username = "";
//
//   @override
//   void initState() {
//     super.initState();
//     getUserData();
//   }
//
//   void getUserData() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     setState(() {
//       username = sh.getString("username") ?? "User";
//     });
//   }
//
//   void logout() async {
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     await sh.clear();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginPage(title: "Login")),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("MediFind"),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: logout,
//           )
//         ],
//       ),
//       drawer: Drawer(
//         child: Column(
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage(
//                     'https://static.vecteezy.com/system/resources/previews/000/962/540/large_2x/doctor-giving-medicine-to-patient-photo.jpg',
//                   ),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Text(
//                   'MediFind',
//                   style: TextStyle(
//                     fontSize: 28,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     shadows: [
//                       Shadow(
//                         blurRadius: 4,
//                         color: Colors.black54,
//                         offset: Offset(2, 2),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.person),
//               title: const Text('View / Edit Profile'),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProfilePage(title: 'my profile')));
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.list_alt),
//               title: const Text('view pharmacies'),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const PharmaciesPage()));
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.list_alt),
//               title: const Text('prescription analysis'),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadPrescriptionPage()));
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.list_alt),
//               title: const Text('set emergency number'),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const SetEmergencyNumberPage()));
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.alarm),
//               title: const Text('Add Reminder'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => MedicineReminder(),
//                   ),
//                 );
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.alarm),
//               title: const Text('view Reminder'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ViewRemindersPage(),
//                   ),
//                 );
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.shopping_cart),
//               title: const Text('My Cart'),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.shopping_cart),
//               title: const Text('Emergency call'),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const CallPage()));
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.receipt),
//               title: const Text('My Orders'),
//               onTap: () {
//                 // Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersPage()));
//               },
//             ),
//             const Spacer(),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Logout'),
//               onTap: logout,
//             ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: Text(
//           'Welcome, $username',
//           style: const TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:medifind/add_reminder.dart';
import 'package:medifind/cart.dart';
import 'package:medifind/nearbypharmacies.dart';
import 'package:medifind/prescriptionanalysis.dart';
import 'package:medifind/set_emergency_number.dart';
import 'package:medifind/view_reminder.dart';
import 'package:medifind/viewprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'call.dart';
import 'login.dart';

void main() {
  runApp(const HomePage(title: 'Home'));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFA5C422),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA5C422),
          primary: const Color(0xFFA5C422),
          secondary: const Color(0xFF8BAE1E), // slightly darker variant
          surface: Colors.white,
          onPrimary: Colors.black87,      // text/icons on primary color
          onSurface: Colors.black87,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFA5C422),
          foregroundColor: Colors.black87,
          elevation: 2,
          centerTitle: true,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        listTileTheme: ListTileThemeData(
          iconColor: Colors.black54,
          textColor: Colors.black87,
          selectedColor: const Color(0xFFA5C422),
          selectedTileColor: const Color(0xFFF0F7D0), // very light green
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA5C422),
            foregroundColor: Colors.black87,
            elevation: 1,
          ),
        ),
      ),
      home: HomeScreen(title: title),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    setState(() {
      username = sh.getString("username") ?? "User";
    });
  }

  void logout() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    await sh.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage(title: "Login")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MediFind",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: logout,
          ),
        ],
      ),

      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFA5C422),
                    Color(0xFF8BAE1E),
                  ],
                ),
                // You can keep image if you want — just lower opacity
                // image: DecorationImage(
                //   image: NetworkImage('https://...'),
                //   fit: BoxFit.cover,
                //   opacity: 0.25,
                // ),
              ),
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'MediFind',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.white.withOpacity(0.7),
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('View / Edit Profile'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyProfilePage(title: 'my profile'),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.local_pharmacy),
                    title: const Text('Nearby Pharmacies'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PharmaciesPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.medical_services),
                    title: const Text('Prescription Analysis'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UploadPrescriptionPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone_in_talk),
                    title: const Text('Set Emergency Number'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SetEmergencyNumberPage()),
                      );
                    },
                  ),
                  const Divider(height: 16, indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.add_alarm),
                    title: const Text('Add Reminder'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MedicineReminder(title: '',)),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.alarm_on),
                    title: const Text('View Reminders'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewRemindersPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: const Text('My Cart'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.emergency),
                    title: const Text('Emergency Call'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CallPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: const Text('My Orders'),
                    onTap: () {
                      // Navigator.push(...);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Orders page coming soon')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
              onTap: logout,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_hospital_rounded,
              size: 80,
              color: const Color(0xFFA5C422).withOpacity(0.7),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome, $username!',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your medicine companion',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}