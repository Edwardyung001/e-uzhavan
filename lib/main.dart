 import 'package:e_uzhavan/user/user_dashboard_view.dart' show UserDashboard;
import 'package:flutter/material.dart';

import 'auth/login_view.dart';




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // Set initial route
      routes: {
        '/login': (context) => LoginPage(), // Define Login Page Route
        '/dashboard': (context) => UserDashboard(), // Define Dashboard Route
      },
    );
  }
}





