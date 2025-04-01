import 'package:e_uzhavan/user/profile.dart' show ProfilePage;
import 'package:e_uzhavan/user/services_view.dart' show ServicesPage;
import 'package:flutter/material.dart';
import 'package:e_uzhavan/db_helper.dart';
import 'package:e_uzhavan/user/farmer_product_view.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cart_view.dart' show CartPage;
import 'home_list_view.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  List<Map<String, dynamic>> farmers = [];
  int _selectedIndex = 0; // Track selected tab
  String? profileImage;


  @override
  void initState() {
    super.initState();
    fetchFarmers();
  }

  Future<void> fetchFarmers() async {
    final db = await DatabaseHelper.instance.database;

    try {
      final List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'role = ?',
        whereArgs: ['Farmer'],
      );
      if (result.isNotEmpty) {
        setState(() {
          profileImage = result.first['profileImage']; // Get image path
        });
      }
      setState(() {
        farmers = result;
      });
    } catch (e) {
      print("Error fetching farmers: $e");
    }
  }

  // Screens for each tab
  List<Widget> getPages() {
    return [
      farmers.isEmpty
          ? Center(
        child: Text(
          "No one has uploaded a product",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      )
          : HomeListScreen(farmers: farmers), // Show list if data exists
      const ServicesPage(),
      const CartPage(cartItems: []),
      const ProfilePage(),
    ];
  }

  String getTitle() {
    switch (_selectedIndex) {
      case 0:
        return "Explore Farmers"; // Home
      case 1:
        return "Our Services"; // Services
      case 2:
        return "Your Cart"; // Cart
      case 3:
        return "Profile"; // Profile
      default:
        return "Explore Farmers";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text(getTitle(), style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[700],
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: getPages()[_selectedIndex], // Show selected tab content
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.miscellaneous_services), label: "Services"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
