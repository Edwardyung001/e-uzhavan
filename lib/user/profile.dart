import 'package:e_uzhavan/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  String userName = "Loading...";
  String userEmail = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }


  Future<void> _loadUserData() async {
    final db = await DatabaseHelper.instance.database;
    final user = await db.query('users', where: 'id = ?', whereArgs: [1]);



    if (user.isNotEmpty) {
      setState(() {
        userName = user[0]['name']?.toString() ?? 'Unknown';
        userEmail = user[0]['email']?.toString() ?? 'Unknown';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/default_profile.jpg"),
              ),
              const SizedBox(height: 10),
              Text(userName, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(userEmail, style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700])),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.green),
                title: Text("Settings", style: GoogleFonts.poppins(fontSize: 16)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text("Logout", style: GoogleFonts.poppins(fontSize: 16, color: Colors.red)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
