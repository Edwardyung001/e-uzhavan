import 'package:e_uzhavan/db_helper.dart';
import 'package:e_uzhavan/admin/farmer_dashboard.dart';
import 'package:e_uzhavan/auth/signup_view.dart';
import 'package:e_uzhavan/user/user_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  Future<void> login(BuildContext context) async {
    final db = await DatabaseHelper.instance.database;
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final List<Map<String, dynamic>> user = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (user.isNotEmpty) {
      String role = user.first['role'];
      int? farmerId = user.first['farmerId'];

      if (role == "Farmer") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FarmerDashboard(farmerId: farmerId!),
          ),
        );
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserDashboard()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid credentials", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  Future<void> showTableData(String tableName) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> rows = await db.query(tableName);

    print("Data in $tableName:");
    for (var row in rows) {
      print(row);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light background
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Illustration
                Image.asset(
                  'assets/images/login.jpg', // Make sure this exists
                  height: 180,
                ),

                Text(
                  "Welcome E-Uzhavan!",
                  style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                // Email Field
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.mail, color: Color(0xFF57E3A6)), // Updated icon
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),

                // Password Field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF57E3A6)), // Keeping it consistent
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => login(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF57E3A6), // Updated button color
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text("Login", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 10),

                // Sign Up Link
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage())),
                  child: Text("Don't have an account? Sign Up", style: GoogleFonts.poppins(color:Colors.black)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
